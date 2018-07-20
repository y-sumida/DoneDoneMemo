import UIKit
import Instantiate
import InstantiateStandard
import RxSwift

class AlarmPickerCell: UITableViewCell {
    typealias Dependency = Variable<Date?>

    @IBOutlet weak var dateTextField: UITextField!

    private var disposeBag: DisposeBag!
    private var bindValue: Variable<Date?>!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func commonInit() {
        let datePickerView = AlarmPickerView(with: Void())
        datePickerView.cancelAction = { [unowned self] in
            self.dateTextField.resignFirstResponder() // TODO もとの値に戻す
        }
        datePickerView.selectedDate
            .skip(1)
            .subscribe(onNext: { [unowned self] date in
                self.dateTextField.text = date.description // TODO 書式
                self.bindValue.value = date
            }).disposed(by: disposeBag)

        dateTextField.inputView = datePickerView
        dateTextField.reloadInputViews()
    }
}

extension AlarmPickerCell: Reusable, NibType {
    func inject(_ dependency: Variable<Date?>) {
        bindValue = dependency
        disposeBag = DisposeBag()
        dateTextField.text = dependency.value?.description ?? "期限なし"
        commonInit()
    }
}
