import UIKit
import Instantiate
import InstantiateStandard

class LicenseCell: UITableViewCell {
    typealias Dependency = (name: String, license: String)

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var licenseLabel: UILabel!
}

extension LicenseCell: Reusable, NibType {
    func inject(_ dependency: (name: String, license: String)) {
        nameLabel.text = dependency.name
        licenseLabel.text = dependency.license
        selectionStyle = .none
    }
}
