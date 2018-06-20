import UIKit
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa
import UserNotifications

final class KeyboardTextView: UIView {
    typealias Dependency = Void
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var alermButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var deadlineClearButton: UIButton!
    weak var delegate: UITextViewDelegate? {
        didSet {
            textView.delegate = delegate
        }
    }
    var sendAction: ((String, Date?) -> Void) = { _, _ in }

    private var deadline: Date?
    private let formatter = DateFormatter()

    private let disposeBag = DisposeBag()

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == textView {
            textView.inputView = nil
            textView.reloadInputViews()
            textView.tintColor = UIColor.black
            return view
        } else if view == alermButton {
            textView.tintColor = UIColor.clear
            return view
        }
        return view
    }

    override var intrinsicContentSize: CGSize {
        let textSize = self.textView.sizeThatFits(CGSize(width: self.textView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: self.bounds.width, height: 8 + textSize.height + 4 + 20 + 8)
    }

    func showKeyboard(title: String = "", deadline: Date? = nil) {
        textView.text = title
        self.deadline = deadline
        invalidateIntrinsicContentSize()
        alermButton.isEnabled = true

        setDeadline(at: deadline)
        textView.becomeFirstResponder()
    }

    func hideKeyboard() {
        textView.text = ""
        setDeadline(at: nil)
        invalidateIntrinsicContentSize()
        textView.resignFirstResponder()
    }

    @IBAction func tapSendButton(_ sender: Any) {
        if let title = textView.text {
            sendAction(title, deadline)
        }
    }
    @IBAction func tapAlermButton(_ sender: Any) {
        let datePickerView = AlarmPickerView(with: Void())
        datePickerView.cancelAction = { [unowned self] in
            self.setDeadline(at: nil)
            self.textView.tintColor = UIColor.black
            self.textView.inputView = nil
            self.textView.reloadInputViews()
        }
        datePickerView.selectedDate
            .skip(1)
            .subscribe(onNext: { [weak self] date in
                self?.setDeadline(at: date)
            }).disposed(by: disposeBag)

        textView.inputView = datePickerView
        textView.reloadInputViews()
        showNotificationAlert()
    }

    @IBAction func tapDeadlineClearButton(_ sender: Any) {
        setDeadline(at: nil)
    }

    private func bind() {
        // タスクが空っぽの場合は登録不可
        textView.rx.text
            .map {
                guard let text = $0 else { return false }
                return text.isNotEmpty
            }
            .bind(to: sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    private func showNotificationAlert() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert]) { (granted, _) in
            if granted {
                print("OK")
            } else {
                print("NG")
            }
        }
    }

    private func setDeadline(at deadline: Date?) {
        self.deadline = deadline

        if let date = deadline {
            deadlineLabel.text = formatter.string(from: date)
            deadlineClearButton.isHidden = false
        } else {
            deadlineLabel.text = "期限なし"
            deadlineClearButton.isHidden = true
        }
    }
}

extension KeyboardTextView: NibInstantiatable {
    func inject(_ dependency: Void) {
        textView.layer.cornerRadius = 4
        sendButton.layer.cornerRadius = 18
        deadlineClearButton.layer.cornerRadius = 10
        setDeadline(at: nil)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy/M/d(EEE) HH:mm"
        bind()
    }
}
