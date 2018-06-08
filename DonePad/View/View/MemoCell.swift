import UIKit
import Instantiate
import InstantiateStandard

class MemoCell: UICollectionViewCell {
    typealias Dependency = Memo
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var remainLabel: UILabel!

    private var title: String = "memo" {
        didSet {
            titleLabel.text = title
        }
    }
    private var remainCount: Int = 0 {
        didSet {
            remainLabel.text = "残 \(remainCount)"
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                let white = UIColor.white
                backgroundColor = white.withAlphaComponent(0.4)
            } else {
                backgroundColor = .white
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension MemoCell: Reusable, NibType {
    func inject(_ dependency: Memo) {
        title = dependency.title
        remainCount = dependency.remainCount
    }
}
