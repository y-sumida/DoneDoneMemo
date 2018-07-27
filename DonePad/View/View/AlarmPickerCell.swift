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
    private var originalDate: Date?

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
            if let date = self.originalDate {
                self.dateTextField.text = self.formatter.string(from: date)
            } else {
                self.dateTextField.text = "期限なし"
            }
            self.bindValue.value = self.originalDate
            self.dateTextField.resignFirstResponder()
        }
        datePickerView.selectedDate
            .skip(1)
            .subscribe(onNext: { [unowned self] date in
                self.dateTextField.text = self.formatter.string(from: date)
                self.bindValue.value = date
            }).disposed(by: disposeBag)

        dateTextField.inputView = datePickerView
        dateTextField.reloadInputViews()

        dateTextField.rx.text.asDriver()
            .drive(onNext: {[unowned self] text in
                if let value: String = text, value.isEmpty {
                    self.dateTextField.text = "期限なし"
                    self.dateTextField.resignFirstResponder() //TODO なぜかキーボードが閉じない
                    self.bindValue.value = nil
                    self.originalDate = nil
                }
            })
            .disposed(by: disposeBag)
    }
}

extension AlarmPickerCell: Reusable, NibType {
    func inject(_ dependency: Variable<Date?>) {
        bindValue = dependency
        originalDate = dependency.value
        disposeBag = DisposeBag()
        commonInit()
    }
}
