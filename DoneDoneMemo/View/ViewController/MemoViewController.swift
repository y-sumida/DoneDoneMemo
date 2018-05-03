import UIKit
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa

final class MemoViewController: UIViewController {
    private var viewModel: MemoViewModel!
    private var accessoryView: KeyboardTextView!
    private let bag = DisposeBag()

    @IBOutlet private weak var tableView: UITableView!

    static var instantiateSource: InstantiateSource { return .identifier(.from(MemoViewController.self)) }

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        if let id = defaults.value(forKey: "memoId") as? String {
            viewModel = MemoViewModel(from: id)
        } else {
            viewModel = MemoViewModel(from: "")
        }

        navigationItem.title = viewModel.title

        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset.bottom = 50
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.registerNib(type: TaskCell.self)

        accessoryView = KeyboardTextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        accessoryView.delegate = self

        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var inputAccessoryView: UIView? {
        return accessoryView
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    private func bind() {
        accessoryView.tapAction = { [weak self] (text: String) in
            self?.addTask(title: text)
        }
    }

    private func addTask(title: String, completion: (() -> Void) = {}) {
        guard title.isNotEmpty else { return }

        tableView.beginUpdates()
        viewModel.addTask(title: title)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        // TODO この方法だと最初の1行追加時にクラッシュするので全体をリロードする
        // attempt to delete row 0 from section 0 which only contains 0 rows before the update
        //tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        tableView.reloadData()
        tableView.endUpdates()
        completion()
    }

    @IBAction func tapListButton(_ sender: Any) {
        let vc = MemoListViewController(with: ())
        let navi = UINavigationController(rootViewController: vc)
        navigationController?.present(navi, animated: true, completion: nil)
    }
}

extension MemoViewController: StoryboardInstantiatable {
    func inject(_ dependency: MemoViewModel) {
        self.viewModel = dependency

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "memoId")
        defaults.setValue(viewModel.memoId, forKey: "memoId")
    }
}

extension MemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTasks
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let task = viewModel.task(at: indexPath.row) else { return UITableViewCell() }
        let cell = TaskCell.dequeue(from: tableView, for: indexPath, with: task)
        cell.tapAction = {[weak self] (text: String) -> Void in
            self?.accessoryView.title = text
            self?.accessoryView.textField.returnKeyType = .done
            self?.accessoryView.showKeyboard()
        }
        return cell
    }
}

extension MemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
        accessoryView.hideKeyboard()
        cell.toggleTask()
        viewModel.toggleDone(at: indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        accessoryView.hideKeyboard()
        return "削除"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, viewModel.numberOfTasks > indexPath.row {
            tableView.beginUpdates()
            viewModel.deleteTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        accessoryView.title = ""
    }
}

extension MemoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard viewModel.numberOfTasks > 0 else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTask(title: textField.text ?? "")
        textField.text = ""
        // TODO もっといい判定方法
        if textField.returnKeyType == .done {
            textField.returnKeyType = .next
            textField.resignFirstResponder()
        }
        return true
    }
}
