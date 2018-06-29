import UIKit
import Instantiate
import InstantiateStandard

final class TutorialViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = Void

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TutorialViewController: StoryboardInstantiatable {
    func inject(_ dependency: Void) {
    }
}
