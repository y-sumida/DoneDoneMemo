import UIKit
import Instantiate
import InstantiateStandard
import RxSwift

class MemoSettingsTitleCell: UITableViewCell {
    typealias Dependency = Variable<String>

    @IBOutlet weak var titleTextField: UITextField!

    private var disposeBag: DisposeBag!
    private var bindValue: Variable<String>!

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func commonInit() {
        titleTextField.returnKeyType = .done
    }
}

extension MemoSettingsTitleCell: Reusable, NibType {
    func inject(_ dependency: Variable<String>) {
        bindValue = dependency
        titleTextField.text = bindValue.value

        disposeBag = DisposeBag()
        titleTextField.rx.text.asDriver()
            .drive(onNext: { text in
                if let value: String = text {
                    self.bindValue.value = value
                }
            })
            .disposed(by: disposeBag)
    }
}
