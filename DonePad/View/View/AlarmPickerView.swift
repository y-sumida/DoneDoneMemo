import UIKit
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa

final class AlarmPickerView: UIView {
    typealias Dependency = Void
    @IBOutlet weak var datePickerView: UIDatePicker!

    var checkAction: ((Date) -> Void) = { _ in }

    var selectedDate: Observable<Date> {
        return _selectedDate.asObservable()
    }
    private let _selectedDate = Variable<Date>(Date())
    private let disposeBag = DisposeBag()

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
        datePickerView.rx.date
            .subscribe(onNext: { date in
                self._selectedDate.value = date
            }).disposed(by: disposeBag)
    }
}
