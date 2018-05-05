import UIKit
import Instantiate
import InstantiateStandard

final class MemoListViewController: UIViewController {
    private var viewModel = MemoListViewModel()
    private var closeAction: ((MemoViewModel) -> Void) = {_ in }
    @IBOutlet private weak var tableView: UITableView!

    // StoryboardInstantiatable
    typealias Dependency = ((MemoViewModel) -> Void)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .black),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        navigationItem.title = "メモ一覧"

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            self.tableView.flashScrollIndicators()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMemos
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        if indexPath.row < viewModel.numberOfMemos {
            cell.textLabel?.text = viewModel.memo(at: indexPath.row)?.title
        }
        return cell
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memo = viewModel.memo(at: indexPath.row) else { return }
        let vm = MemoViewModel(from: memo)
        closeAction(vm)
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, viewModel.numberOfMemos > indexPath.row {
            tableView.beginUpdates()
            viewModel.deleteMemo(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

extension MemoListViewController: StoryboardInstantiatable {
    func inject(_ dependency: @escaping ((MemoViewModel) -> Void)) {
        closeAction = dependency
    }
}
