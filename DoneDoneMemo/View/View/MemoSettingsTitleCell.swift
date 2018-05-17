import UIKit
import Instantiate
import InstantiateStandard

class MemoSettingsTitleCell: UITableViewCell {
    typealias Dependency = String

    @IBOutlet weak var titleTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension MemoSettingsTitleCell: Reusable, NibType {
    func inject(_ dependency: String) {
       titleTextField.text = dependency
    }
}
