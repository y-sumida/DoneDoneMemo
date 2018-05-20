import UIKit
import Instantiate
import InstantiateStandard

final class MemoSettingsViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = MemoSettingsViewModel
    private var viewModel: MemoSettingsViewModel!
    private var content: MemoSettingsContentViewController!

    @IBOutlet private weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "メモの設定"

        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(self.close))
        navigationItem.leftBarButtonItem = closeButton

        content = MemoSettingsContentViewController(with: viewModel)
        addChildViewController(content)
        content.view.frame = self.view.bounds
        view.addSubview(content.view)
        view.bringSubview(toFront: saveButton)
        content.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: Any) {
        viewModel.updateMemo()
        close()
    }
}

extension MemoSettingsViewController: StoryboardInstantiatable {
    func inject(_ dependency: MemoSettingsViewModel) {
        viewModel = dependency
    }
}
