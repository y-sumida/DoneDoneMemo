import UIKit
import Instantiate
import InstantiateStandard

class MemoCollectionViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    private var viewModel = MemoListViewModel()
    private var closeAction: ((MemoViewModel) -> Void) = {_ in }
    // StoryboardInstantiatable
    typealias Dependency = ((MemoViewModel) -> Void)

    let animator = ZoomOutAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .black),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.registerNib(type: MemoCell.self)
        collectionView.registerNib(type: MemoAddCell.self)

        navigationController?.transitioningDelegate = self

        setupNavigationItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupNavigationItems() {
        navigationItem.title = "メモ一覧"

        let settingButton = UIButton()
        settingButton.addTarget(self, action: #selector(self.showSettings), for: .touchUpInside)
        settingButton.setImage(UIImage(named: "ic_setting")?.withRenderingMode(.alwaysTemplate), for: .normal)
        settingButton.tintColor = UIColor.black
        let setting = UIBarButtonItem(customView: settingButton)
        navigationItem.rightBarButtonItem = setting
    }

    @objc private func showSettings() {
        let vc = AppSettingsViewController(with: Void())
        let navi = UINavigationController(rootViewController: vc)
        navigationController?.present(navi, animated: true, completion: nil)
    }
}

extension MemoCollectionViewController: StoryboardInstantiatable {
    func inject(_ dependency: @escaping ((MemoViewModel) -> Void)) {
        closeAction = dependency
    }
}

extension MemoCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMemos + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let memo = viewModel.memo(at: indexPath.row) else {
           return MemoAddCell.dequeue(from: collectionView, for: indexPath)
        }
        let cell = MemoCell.dequeue(from: collectionView, for: indexPath, with: memo)
        return cell
    }
}

extension MemoCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm: MemoViewModel!
        if let memo = viewModel.memo(at: indexPath.row) {
            vm = MemoViewModel(from: memo)
        } else {
            let memo = viewModel.addMemo()
            vm = MemoViewModel(from: memo)
        }
        closeAction(vm)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension MemoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.size.width/2 - 1
        return CGSize(width: size, height: size * 0.6)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

extension MemoCollectionViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}
