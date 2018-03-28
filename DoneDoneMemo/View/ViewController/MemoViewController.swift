import UIKit
import Instantiate
import InstantiateStandard

final class MemoViewController: UIViewController {
    private var content: MemoContentViewController!
    private var viewModel: MemoViewModel!

    @IBOutlet weak var addButton: AddButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.title

        content = MemoContentViewController(with: viewModel)
        addChildViewController(content)
        content.view.frame = self.view.bounds
        self.view.addSubview(content.view)
        content.didMove(toParentViewController: self)

        self.view.bringSubview(toFront: addButton)
    }
}

extension MemoViewController: StoryboardInstantiatable {
    func inject(_ dependency: MemoViewModel) {
        self.viewModel = dependency
    }
}
