import UIKit
import Instantiate
import InstantiateStandard
import RxSwift

class MemoSettingsTitleCell: UITableViewCell {
    typealias Dependency = Variable<String>

    @IBOutlet weak var titleTextField: UITextField!

    private var disposeBag: DisposeBag!
    private var bindValue: Variable<String>! {
        didSet {
            disposeBag = DisposeBag()
            bindValue.asObservable()
                .distinctUntilChanged()
                .subscribe(onNext: {[weak self] value in
                    self?.titleTextField.text = value
                })
                .disposed(by: disposeBag)

            titleTextField.rx.text
                .bind { string in
                    if let value: String = string {
                        self.bindValue.value = value
                    }
                }
                .disposed(by: disposeBag)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension MemoSettingsTitleCell: Reusable, NibType {
    func inject(_ dependency: Variable<String>) {
        bindValue = dependency
        titleTextField.text = bindValue.value
    }
}
