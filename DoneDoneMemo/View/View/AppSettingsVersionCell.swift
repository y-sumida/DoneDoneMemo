import UIKit
import Instantiate
import InstantiateStandard

class AppSettingsVersionCell: UITableViewCell {
    typealias Dependency = String
    @IBOutlet private weak var versionLabel: UILabel!
}

extension AppSettingsVersionCell: Reusable, NibType {
    func inject(_ dependency: String) {
        versionLabel.text = dependency
        selectionStyle = .none
    }
}
