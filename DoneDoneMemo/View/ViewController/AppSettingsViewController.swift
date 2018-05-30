import UIKit
import Instantiate
import InstantiateStandard

final class AppSettingsViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = Void

    @IBOutlet private weak var tableView: UITableView!

    private var viewModel = AppSettingsViewModel()
    private var licenses: [License] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        licenses = readLicenses()

        tableView.dataSource = self
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

    // TODO Modelに移動する
    private func readLicenses() -> [License] {
        guard let path: URL = Bundle.main.url(forResource: "Settings.bundle/com.mono0926.LicensePlist", withExtension: "plist") else {
            return []
        }

        var licenses: Licenses?

        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            licenses = try? decoder.decode(Licenses.self, from: data)

            if let items = licenses?.items {
                return items
            }
        }
        return []
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
