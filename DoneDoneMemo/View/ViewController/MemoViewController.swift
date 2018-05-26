import UIKit
import RxSwift
import RxCocoa

final class MemoViewController: UIViewController {
    private var viewModel: MemoViewModel! {
        didSet {
            navigationItem.title = viewModel.title
            saveMemoId()
            tableView.reloadData()
        }
    }
    private var accessoryView: KeyboardTextView!
    private let disposeBag = DisposeBag()

    private var editingIndex: IndexPath?

    let animator = ZoomInAnimator()

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        if let id = defaults.value(forKey: "memoId") as? String {
            viewModel = MemoViewModel(from: id)
        } else {
            viewModel = MemoViewModel(from: "")
        }

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editingIndex = nil
        viewModel.reload()
        navigationItem.title = viewModel.title
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        accessoryView.isHidden = false
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

    private func saveMemoId() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "memoId")
        defaults.setValue(viewModel.memoId, forKey: "memoId")
    }

    private func clearMemoId() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "memoId")
    }

    private func addTask(title: String, completion: (() -> Void) = {}) {
        guard title.isNotEmpty else { return }

        tableView.beginUpdates()
        viewModel.addTask(title: title)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        // 行ごとのリロードだと、最初の1行追加時にクラッシュするので全体をリロードする
        if viewModel.numberOfTasks > 1 {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        } else {
            tableView.reloadData()
        }
        tableView.endUpdates()
        completion()
    }

    private func editTask(at indexPath: IndexPath, title: String) {
        guard title.isNotEmpty else { return }
        viewModel.editTask(at: indexPath.row, title: title)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    @IBAction func tapSettingsButton(_ sender: Any) {
        showSettings()
    }

    @IBAction func tapTrashButton() {
        accessoryView.isHidden = true
        let alert = UIAlertController(title: "削除しますか？", message: nil, preferredStyle: .actionSheet)
        let deleteAll = UIAlertAction(title: "メモごと削除する", style: .default, handler: {[unowned self] _ in
            self.viewModel.delete()
            self.clearMemoId()
            self.showMemoList()
        })
        let deleteDone = UIAlertAction(title: "チェック済タスクを削除する", style: .default, handler: {[unowned self] _ in
            self.viewModel.deleteDone()
            self.tableView.reloadData()
            self.accessoryView.isHidden = false
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: {[unowned self] _ in
           self.accessoryView.isHidden = false
        })
        alert.addAction(deleteAll)
        alert.addAction(deleteDone)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    @objc private func showMemoList() {
        accessoryView.isHidden = true
        let vc = MemoCollectionViewController(with: { memo in
            self.viewModel = memo
        })
        accessoryView.hideKeyboard()
        let navi = UINavigationController(rootViewController: vc)
        navi.transitioningDelegate = self
        navigationController?.present(navi, animated: true, completion: nil)
    }

    private func showSettings() {
        accessoryView.isHidden = true
        let vm = MemoSettingsViewModel(from: viewModel.memoId)
        let vc = MemoSettingsViewController(with: vm)
        let navi = UINavigationController(rootViewController: vc)
        navigationController?.present(navi, animated: true, completion: nil)
    }

    @IBAction func tapListButton(_ sender: Any) {
        showMemoList()
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
            cell.setSelected(true, animated: true)
            self?.editingIndex = indexPath
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
}

extension MemoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard viewModel.numberOfTasks > 0 else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        accessoryView.title = ""
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        if let index = editingIndex {
            editTask(at: index, title: text)
            textField.returnKeyType = .next
            textField.resignFirstResponder()
        } else {
            addTask(title: text)
        }

        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
        textField.text = ""
        return true
    }
}

extension MemoViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
