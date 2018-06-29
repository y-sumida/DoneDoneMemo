import UIKit
import Instantiate
import InstantiateStandard

final class TutorialViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = String
    @IBOutlet private weak var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func tapButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension TutorialViewController: StoryboardInstantiatable, ViewLoadBeforeInject {
    func inject(_ dependency: String) {
        messageLabel.text = dependency
    }
}
