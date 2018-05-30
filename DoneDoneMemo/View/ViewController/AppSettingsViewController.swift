import UIKit
import Instantiate
import InstantiateStandard

final class AppSettingsViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = Void

    @IBOutlet private weak var tableView: UITableView!

    private var viewModel = AppSettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(self.close))
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.title = "アプリの設定"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AppSettingsViewController: StoryboardInstantiatable {
    func inject(_ dependency: Void) {
    }
}

extension AppSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.title(for: indexPath)
        return cell
    }
}

extension AppSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO ライセンス以外
        if indexPath.row == 1 {
            let vc = LicensesViewController(with: Void())
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
