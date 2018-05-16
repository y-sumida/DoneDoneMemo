import UIKit
import Instantiate
import InstantiateStandard

final class MemoSettingsViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = MemoViewModel
    private var viewModel: MemoViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.title + "の設定"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MemoSettingsViewController: StoryboardInstantiatable {
    func inject(_ dependency: MemoViewModel) {
        viewModel = dependency
    }
}
