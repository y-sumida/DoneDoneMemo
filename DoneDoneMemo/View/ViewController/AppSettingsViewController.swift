import UIKit
import Instantiate
import InstantiateStandard

final class AppSettingsViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = Void

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO tableViewに表示する
        _ = readLicenses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // TODO Modelに移動する
    private func readLicenses() -> [String: String] {
        guard let path: URL = Bundle.main.url(forResource: "Settings.bundle/com.mono0926.LicensePlist", withExtension: "plist") else {
            return [:]
        }

        do {
            let data: Data = try Data(contentsOf: path)
            let properties = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any]

            var licenses: [String: String] = [:]
            if let preference = properties?["PreferenceSpecifiers"] as? [[String: Any]] {
                preference.forEach {
                    if let title = $0["Title"] as? String,
                        let path = $0["File"] as? String {
                        licenses[title] = path
                    }
                }
            }
            dump(licenses)
            return licenses
        } catch {
            return [:]
        }
    }
}

extension AppSettingsViewController: StoryboardInstantiatable {
    func inject(_ dependency: Void) {
    }
}
