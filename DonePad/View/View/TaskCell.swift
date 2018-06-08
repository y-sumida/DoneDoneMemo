import UIKit
import Instantiate
import InstantiateStandard

final class TaskCell: UITableViewCell {
    typealias Dependency = Task

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!

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

    private var title: String = "task" {
        didSet {
            titleLabel.text = title
        }
    }

    func toggleTask() {
        setSelected(true, animated: true)
        done = !done
        setSelected(false, animated: true)
    }

    func configure(task: Task) {
        title = task.title
        done = task.done
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
        title = dependency.title
        done = dependency.done
    }
}