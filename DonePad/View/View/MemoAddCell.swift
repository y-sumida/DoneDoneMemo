import UIKit
import Instantiate
import InstantiateStandard

class MemoAddCell: UICollectionViewCell {
    typealias Dependency = Void

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

extension MemoAddCell: Reusable, NibType {
}
