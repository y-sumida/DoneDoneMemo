import UIKit
import Instantiate
import InstantiateStandard

class MemoViewController: UIViewController {
    private var content: MemoContentViewController!
    private var viewModel: MemoViewModel!

    @IBOutlet weak var addButton: AddButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        content = MemoContentViewController(with: viewModel)
        addChildViewController(content)
        content.view.frame = self.view.bounds
        self.view.addSubview(content.view)
        content.didMove(toParentViewController: self)

        self.view.bringSubview(toFront: addButton)
    }
}

extension MemoViewController: StoryboardInstantiatable {
    func inject(_ dependency: MemoViewModel) {
        self.viewModel = dependency
    }
}

class MemoContentViewController: UIViewController {
    var viewModel: MemoViewModel!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .black),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        navigationItem.title = viewModel.title

        tableView.dataSource = self
        tableView.delegate = self

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
        return cell
    }
}

extension MemoContentViewController: UITableViewDelegate {
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

