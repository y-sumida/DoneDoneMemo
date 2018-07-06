import UIKit
import Instantiate
import InstantiateStandard

final class MemoSettingsContentViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = MemoSettingsViewModel
    private var viewModel: MemoSettingsViewModel!

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(type: InputTextCell.self)
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MemoSettingsContentViewController: StoryboardInstantiatable {
    func inject(_ dependency: MemoSettingsViewModel) {
        viewModel = dependency
    }
}


extension MemoSettingsContentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = InputTextCell.dequeue(from: tableView, for: indexPath, with: viewModel.title)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "メモのタイトル"
    }
}
