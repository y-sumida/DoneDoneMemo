import UIKit
import Instantiate
import InstantiateStandard
import RxSwift

final class MemoSettingsViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = MemoSettingsViewModel
    private var viewModel: MemoSettingsViewModel!
    private var content: MemoSettingsContentViewController!

    private let disposeBag = DisposeBag()

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

        let closeButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.close))
        closeButton.tintColor = UIColor.black
        closeButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .light)], for: .normal)
        navigationItem.leftBarButtonItem = closeButton
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.save))
        saveButton.tintColor = UIColor.black
        saveButton.setTitleTextAttributes([.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 17, weight: .light)], for: .disabled)

        let original = viewModel.title.value
        viewModel.title.asObservable()
            .subscribe(onNext: {
               saveButton.isEnabled = ($0.isNotEmpty && $0 !=  original)
            })
            .disposed(by: disposeBag)

        navigationItem.rightBarButtonItem = saveButton
    }
}

extension MemoSettingsViewController: StoryboardInstantiatable {
    func inject(_ dependency: MemoSettingsViewModel) {
        viewModel = dependency
    }
}
