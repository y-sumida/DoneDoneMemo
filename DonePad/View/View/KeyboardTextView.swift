import UIKit
import Instantiate
import InstantiateStandard

final class KeyboardTextView: UIView {
    typealias Dependency = Void
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    weak var delegate: UITextViewDelegate? {
        didSet {
            textView.delegate = delegate
        }
    }

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
        return CGSize(width: self.bounds.width, height: textSize.height + 16)
    }

    func showKeyboard(title: String = "") {
        textView.text = title
        invalidateIntrinsicContentSize()
        timerButton.isEnabled = true
        textView.becomeFirstResponder()
    }

    func hideKeyboard() {
        textView.text = ""
        invalidateIntrinsicContentSize()
        textView.resignFirstResponder()
    }

    @IBAction func tapTimerButton(_ sender: Any) {
        let datePickerView = AlarmPickerView(with: Void())
        textView.inputView = datePickerView
        textView.reloadInputViews()
    }
}

extension KeyboardTextView: NibInstantiatable {
    func inject(_ dependency: Void) {
        textView.layer.cornerRadius = 4
        sendButton.layer.cornerRadius = 18
    }
}
