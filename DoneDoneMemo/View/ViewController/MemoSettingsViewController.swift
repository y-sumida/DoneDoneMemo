import UIKit
import Instantiate
import InstantiateStandard

final class MemoSettingsViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = MemoSettingsViewModel
    private var viewModel: MemoSettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.title + "の設定"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MemoSettingsViewController: StoryboardInstantiatable {
    func inject(_ dependency: MemoSettingsViewModel) {
        viewModel = dependency
    }
}
