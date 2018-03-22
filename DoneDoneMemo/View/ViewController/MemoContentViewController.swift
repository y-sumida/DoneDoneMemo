import UIKit
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa

class MemoContentViewController: UIViewController {
    var viewModel: MemoViewModel!

    private let bag: DisposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag

        let nib = UINib(nibName: "TaskCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TaskCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            cell.task = task
        }
        cell.doneButton.rx.tap.subscribe(onNext: { _ in
            guard let index = tableView.indexPath(for: cell) else { return }
            self.viewModel.toggleDone(at: index.row)
        }).disposed(by: bag)

        return cell
    }
}

extension MemoContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
        cell.setSelected(true, animated: true)
        cell.toggleTask()
        cell.setSelected(false, animated: true)
        viewModel.toggleDone(at: indexPath.row)
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, viewModel.numberOfTasks > indexPath.row {
            viewModel.deleteTask(at: indexPath.row)
            tableView.reloadData() // TODO RxSwiftで検知する
        }
    }
}
