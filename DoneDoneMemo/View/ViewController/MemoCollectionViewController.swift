import UIKit
import Instantiate
import InstantiateStandard

class MemoCollectionViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Parameter = Void

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension MemoCollectionViewController: StoryboardInstantiatable {
}
