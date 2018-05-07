import UIKit
import Instantiate
import InstantiateStandard

class MemoCollectionViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Parameter = Void

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .black),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        navigationItem.title = "メモ一覧"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MemoCollectionViewController: StoryboardInstantiatable {
}
