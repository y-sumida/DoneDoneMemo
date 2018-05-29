import UIKit
import Instantiate
import InstantiateStandard

final class AppSettingsViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = Void

    @IBOutlet private weak var tableView: UITableView!

    private var licenses: [(title: String, path: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        licenses = readLicenses()

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // TODO Modelに移動する
    private func readLicenses() -> [(title: String, path: String)] {
        guard let path: URL = Bundle.main.url(forResource: "Settings.bundle/com.mono0926.LicensePlist", withExtension: "plist") else {
            return []
        }

        do {
            let data: Data = try Data(contentsOf: path)
            let properties = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any]

            var licenses: [(title: String, path: String)] = []
            if let preference = properties?["PreferenceSpecifiers"] as? [[String: Any]] {
                preference.forEach {
                    if let title = $0["Title"] as? String,
                        let path = $0["File"] as? String {
                        licenses.append((title: title, path: path))
                    }
                }
            }
            dump(licenses)
            return licenses
        } catch {
            return []
        }
    }
}

extension AppSettingsViewController: StoryboardInstantiatable {
    func inject(_ dependency: Void) {
    }
}

extension AppSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return licenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < licenses.count else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = licenses[indexPath.row].title
        return cell
    }
}
