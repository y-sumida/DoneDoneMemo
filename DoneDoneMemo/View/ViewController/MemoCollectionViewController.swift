import UIKit
import Instantiate
import InstantiateStandard

class MemoCollectionViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    private var viewModel = MemoListViewModel()
    private var closeAction: ((MemoViewModel) -> Void) = {_ in }
    // StoryboardInstantiatable
    typealias Dependency = ((MemoViewModel) -> Void)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .black),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        navigationItem.title = "メモ一覧"

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.registerNib(type: MemoCell.self)
        collectionView.registerNib(type: MemoAddCell.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        guard let memo = viewModel.memo(at: indexPath.row) else { return }
        let vm = MemoViewModel(from: memo)
        closeAction(vm)
        self.dismiss(animated: true, completion: nil)
    }
}

extension MemoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.size.width/2
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
