import UIKit
import Instantiate
import InstantiateStandard

final class TaskDetailViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = Void
}

extension TaskDetailViewController: StoryboardInstantiatable {
    func inject(_ dependency: Void) {}
}
