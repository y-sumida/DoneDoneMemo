import UIKit
import Instantiate
import InstantiateStandard

final class KeyboardTextView: UIView {
    typealias Dependency = Void
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var timerButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var deadlineClearButton: UIButton!
    weak var delegate: UITextViewDelegate? {
        didSet {
            textView.delegate = delegate
        }
    }
    var addAction: ((String, Date?) -> Void) = { _, _ in }

    private var deadline: Date?
    private let formatter = DateFormatter()

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == textView {
            textView.inputView = nil
            textView.reloadInputViews()
            textView.tintColor = UIColor.black
            return view
        } else if view == timerButton {
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
        invalidateIntrinsicContentSize()
        timerButton.isEnabled = true

        if let date = deadline {
            deadlineLabel.text = date.description
            deadlineClearButton.isHidden = false
        } else {
            deadlineLabel.text = "期限なし"
            deadlineClearButton.isHidden = true
        }
        textView.becomeFirstResponder()
    }

    func hideKeyboard() {
        textView.text = ""
        deadlineLabel.text = "期限なし"
        deadlineClearButton.isHidden = true
        invalidateIntrinsicContentSize()
        textView.resignFirstResponder()
    }

    @IBAction func tapAddButton(_ sender: Any) {
        if let title = textView.text {
            addAction(title, deadline)
        }
    }
    @IBAction func tapTimerButton(_ sender: Any) {
        let datePickerView = AlarmPickerView(with: Void())
        datePickerView.checkAction = { [unowned self] date in
            self.deadlineLabel.text = self.formatter.string(from: date)
            self.deadline = date
            self.deadlineClearButton.isHidden = false
        }
        textView.inputView = datePickerView
        textView.reloadInputViews()
    }

    @IBAction func tapDeadlineClearButton(_ sender: Any) {
        deadline = nil
        deadlineLabel.text = "期限なし"
        deadlineClearButton.isHidden = true
    }
}

extension KeyboardTextView: NibInstantiatable {
    func inject(_ dependency: Void) {
        textView.layer.cornerRadius = 4
        sendButton.layer.cornerRadius = 18
        deadlineClearButton.layer.cornerRadius = 10
        deadlineLabel.text = "期限なし"
        deadlineClearButton.isHidden = true
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy/M/d(EEE) HH:mm"
    }
}
