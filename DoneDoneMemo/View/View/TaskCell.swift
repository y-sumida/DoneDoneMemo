import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIButton!

    var done: Bool = false {
        didSet {
            editButton.isEnabled = !done
            // TODO 取り消し線とかチェックマークとか
            self.toggleTask()
        }
    }

    var task: String = "task" {
        didSet {
            let stringAttributes: [NSAttributedStringKey: Any] = [
                .font: UIFont.systemFont(ofSize: 17, weight: .black)
            ]
            let string = NSAttributedString(string: task, attributes: stringAttributes)
            textField.attributedText = string
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.isUserInteractionEnabled = false // いらない？
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func tapDoneButton(_ sender: Any) {
        done = !done
    }

    @IBAction func tapEditButton(_ sender: Any) {
        textField.becomeFirstResponder()
    }

    private func toggleTask() {
        if let attributedText = textField.attributedText {
            var stringAttributes: [NSAttributedStringKey: Any] = [
                .font: UIFont.systemFont(ofSize: 17, weight: .black)
            ]
            if done {
                stringAttributes[.strikethroughStyle] = 2
                stringAttributes[.foregroundColor] = UIColor.lightGray
            }
            let string = NSAttributedString(string: attributedText.string, attributes: stringAttributes)
            textField.attributedText = string
        }
    }
}
