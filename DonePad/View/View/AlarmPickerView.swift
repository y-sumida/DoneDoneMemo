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
}

extension AlarmPickerView: NibInstantiatable {
    func inject(_ dependency: Void) {
        datePickerView.minimumDate = Date()
        datePickerView.calendar = Calendar(identifier: .gregorian)
        datePickerView.locale = Locale.autoupdatingCurrent
        datePickerView.timeZone = TimeZone.autoupdatingCurrent
    }
}
