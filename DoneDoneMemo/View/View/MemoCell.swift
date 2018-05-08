import UIKit
import Instantiate
import InstantiateStandard

class MemoCell: UICollectionViewCell {
    typealias Dependency = Memo
    @IBOutlet private weak var titleLabel: UILabel!

    private var title: String = "memo" {
        didSet {
            titleLabel.text = title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

extension MemoCell: Reusable, NibType {
    func inject(_ dependency: Memo) {
        title = dependency.title
    }
}
