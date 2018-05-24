import UIKit
import Instantiate
import InstantiateStandard

final class MemoSettingsViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = MemoSettingsViewModel
    private var viewModel: MemoSettingsViewModel!
    private var content: MemoSettingsContentViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()

        content = MemoSettingsContentViewController(with: viewModel)
        addChildViewController(content)
        content.view.frame = self.view.bounds
        view.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func save() {
        viewModel.updateMemo()
        close()
    }

    private func setupNavigationItem() {
        navigationItem.title = "メモの設定"

        let closeButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(self.close))
        navigationItem.leftBarButtonItem = closeButton
        // TODO 変化があるまでisEnabled = false
        let saveButton = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(self.save))
        navigationItem.rightBarButtonItem = saveButton
    }
}

extension MemoSettingsViewController: StoryboardInstantiatable {
    func inject(_ dependency: MemoSettingsViewModel) {
        viewModel = dependency
    }
}
