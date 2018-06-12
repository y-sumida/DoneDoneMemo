import UIKit
import Instantiate
import InstantiateStandard

final class KeyboardTextView: UIView {
    typealias Dependency = Void
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var timerButton: UIButton!
    weak var delegate: UITextViewDelegate? {
        didSet {
            textView.delegate = delegate
        }
    }

    var title: String = "" {
        didSet {
            textView.text = title
            invalidateIntrinsicContentSize()
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
        return nil
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = self.window {
                bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow(window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        let textSize = self.textView.sizeThatFits(CGSize(width: self.textView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: self.bounds.width, height: textSize.height + 16)
    }

    func showKeyboard() {
       textView.becomeFirstResponder()
    }

    func hideKeyboard() {
        textView.text = ""
        invalidateIntrinsicContentSize()
        textView.resignFirstResponder()
    }

    @IBAction func tapTimerButton(_ sender: Any) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        textView.inputView = datePickerView
        textView.reloadInputViews()
    }
}

extension KeyboardTextView: NibInstantiatable {
    func inject(_ dependency: Void) {
        textView.layer.cornerRadius = 4
    }
}
