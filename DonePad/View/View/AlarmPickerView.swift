import UIKit
import Instantiate
import InstantiateStandard

final class AlarmPickerView: UIView {
    typealias Dependency = Void
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBAction func check(_ sender: Any) {
        // TODO あとで実装
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
