import UIKit
import Instantiate
import InstantiateStandard

final class LicensesViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = Void

    @IBOutlet private weak var tableView: UITableView!

    private var viewModel = LicensesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LicensesViewController: StoryboardInstantiatable {
    func inject(_ dependency: Void) {
    }
}

extension LicensesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.numberOfRows else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.title(for: indexPath.row)
        return cell
    }
}
