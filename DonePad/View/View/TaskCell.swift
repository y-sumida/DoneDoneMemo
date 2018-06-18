import UIKit
import Instantiate
import InstantiateStandard

final class TaskCell: UITableViewCell {
    typealias Dependency = Task

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var deadlineLabelHeight: NSLayoutConstraint!

    private let doneImage = UIImage(named: "ic_done")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    private let boxImage = UIImage(named: "ic_checkbox")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)

    private var done: Bool = false {
        didSet {
            if done {
                check()
            } else {
                uncheck()
            }
        }
    }

    private let formatter = DateFormatter()

    func toggleTask() {
        setSelected(true, animated: true)
        done = !done
        setSelected(false, animated: true)
    }

    private func check() {
        if let attributedText = titleLabel.attributedText {
            let stringAttributes: [NSAttributedStringKey: Any] = [
                .font: UIFont.systemFont(ofSize: 20),
                .strikethroughStyle: 2,
                .foregroundColor: UIColor.lightGray
            ]
            let string = NSAttributedString(string: attributedText.string, attributes: stringAttributes)
            titleLabel.attributedText = string
        }

        iconView.image = doneImage
        iconView.tintColor = UIColor.lightGray
    }

    private func uncheck() {
        if let attributedText = titleLabel.attributedText {
            let stringAttributes: [NSAttributedStringKey: Any] = [
                .font: UIFont.systemFont(ofSize: 20)
            ]
            let string = NSAttributedString(string: attributedText.string, attributes: stringAttributes)
            titleLabel.attributedText = string
        }

        iconView.image = boxImage
        iconView.tintColor = UIColor.gray
    }
}

extension TaskCell: Reusable, NibType {
    func inject(_ dependency: Task) {
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy/M/d(EEE) HH:mm"
        titleLabel.text = dependency.title
        if let deadline = dependency.deadline {
            deadlineLabel.isHidden = false
            deadlineLabelHeight.constant = 18
            deadlineLabel.text = formatter.string(from: deadline)
        } else {
            deadlineLabel.isHidden = true
            deadlineLabelHeight.constant = 0
        }
        done = dependency.done
    }
}
