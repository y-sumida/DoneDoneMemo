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
        return viewModel.numberOfMemos
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
}
