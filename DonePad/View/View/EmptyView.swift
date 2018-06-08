import UIKit
import Instantiate
import InstantiateStandard

final class EmptyView: UIView, NibInstantiatable {
    typealias Dependency = String
    @IBOutlet weak var messageLabel: UILabel!

    func inject(_ dependency: String) {
        messageLabel.text = dependency
    }
}
