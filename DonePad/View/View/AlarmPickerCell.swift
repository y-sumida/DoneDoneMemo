import UIKit
import Instantiate
import InstantiateStandard
import RxSwift

class AlarmPickerCell: UITableViewCell {
    typealias Dependency = Variable<Date?>

    @IBOutlet weak var dateTextField: UITextField!

    private let formatter = DateFormatter()
    private var disposeBag: DisposeBag!
    private var bindValue: Variable<Date?>!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func commonInit() {
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy/M/d(EEE) HH:mm"
        if let date = bindValue.value {
            dateTextField.text = formatter.string(from: date)
        } else {
            dateTextField.text = "期限なし"
        }

        let datePickerView = AlarmPickerView(with: Void())
        datePickerView.cancelAction = { [unowned self] in
            self.dateTextField.resignFirstResponder() // TODO もとの値に戻す
        }
        datePickerView.selectedDate
            .skip(1)
            .subscribe(onNext: { [unowned self] date in
                self.dateTextField.text = self.formatter.string(from: date)
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
        commonInit()
    }
}
