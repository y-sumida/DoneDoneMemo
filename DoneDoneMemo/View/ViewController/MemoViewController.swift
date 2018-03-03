import UIKit

class MemoViewController: UIViewController {
    var viewModel: MemoViewModel?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.memo.tasks.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let vm = viewModel else { return UITableViewCell() }

        if indexPath.row < vm.memo.tasks.count {
            cell.textLabel?.text = vm.memo.tasks[indexPath.row].title
        }
        return cell
    }
}
