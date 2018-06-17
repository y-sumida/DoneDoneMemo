import UIKit
import Instantiate
import InstantiateStandard

final class AlarmPickerView: UIView {
    typealias Dependency = Void
    @IBOutlet weak var datePickerView: UIDatePicker!

    var checkAction: ((Date) -> Void) = { _ in }

    @IBAction func check(_ sender: Any) {
        checkAction(datePickerView.date)
    }
    @IBAction func cancel(_ sender: Any) {
        // TODO あとで実装
    }
}

extension AlarmPickerView: NibInstantiatable {
    func inject(_ dependency: Void) {
        datePickerView.minimumDate = Date()
        datePickerView.calendar = Calendar(identifier: .gregorian)
        datePickerView.locale = Locale.current
        datePickerView.timeZone = TimeZone.current
    }
}
