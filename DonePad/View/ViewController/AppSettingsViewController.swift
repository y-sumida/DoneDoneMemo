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
        tableView.registerNib(type: AppSettingsVersionCell.self)

        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.close))
        closeButton.tintColor = UIColor.black
        closeButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .light)], for: .normal)
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.title = "アプリの設定"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
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
        switch indexPath.section {
        case 0:
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
            let cell = AppSettingsVersionCell.dequeue(from: tableView, for: indexPath, with: version)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = viewModel.title(for: indexPath)
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension AppSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = LicensesViewController(with: Void())
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
            backButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .light)], for: .normal)
            backButton.tintColor = UIColor.black
            navigationItem.backBarButtonItem = backButton
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
