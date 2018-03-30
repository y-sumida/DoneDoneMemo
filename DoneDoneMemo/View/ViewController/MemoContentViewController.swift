import UIKit
import Instantiate
import InstantiateStandard
import RxCocoa

final class MemoContentViewController: UIViewController {
    private var viewModel: MemoViewModel!
    private var accessoryView: KeyboardTextView!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset.bottom = 50

        let nib = UINib(nibName: "TaskCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TaskCell")

        accessoryView = KeyboardTextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        accessoryView.textField.delegate = self
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
}

extension MemoContentViewController: StoryboardInstantiatable {
    func inject(_ dependency: MemoViewModel) {
        self.viewModel = dependency
    }
}

extension MemoContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTasks
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as? TaskCell else { return UITableViewCell() }
        if let task = viewModel.task(at: indexPath.row) {
            cell.configure(task: task)
        }
        return cell
    }
}

extension MemoContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
        cell.toggleTask()
        viewModel.toggleDone(at: indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, viewModel.numberOfTasks > indexPath.row {
            viewModel.deleteTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension MemoContentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO リロード
        if let title = textField.text {
            viewModel.addTask(title: title)
        }
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
}
