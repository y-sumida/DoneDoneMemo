import UIKit
import Instantiate
import InstantiateStandard

final class MemoSettingsViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = MemoSettingsViewModel
    private var viewModel: MemoSettingsViewModel!

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.title + "の設定"

        tableView.registerNib(type: MemoSettingsTitleCell.self)
        tableView.dataSource = self

        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(self.close))
        navigationItem.leftBarButtonItem = closeButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MemoSettingsViewController: StoryboardInstantiatable {
    func inject(_ dependency: MemoSettingsViewModel) {
        viewModel = dependency
    }
}


extension MemoSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MemoSettingsTitleCell.dequeue(from: tableView, for: indexPath, with: viewModel.title)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "メモのタイトル"
    }
}
