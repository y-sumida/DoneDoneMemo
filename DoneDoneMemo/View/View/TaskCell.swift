import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var iconView: UIImageView!

    let doneImage = UIImage(named: "ic_done")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    let boxImage = UIImage(named: "ic_checkbox")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)

    private var done: Bool = false {
        didSet {
            editButton.isEnabled = !done
            if done {
                check()
            } else {
                uncheck()
            }
        }
    }

    private var title: String = "task" {
        didSet {
            textField.text = title
        }
    }

    var task: Task? {
        didSet {
            guard let value = task else { return }
            title = value.title
            done = value.done
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.isUserInteractionEnabled = false // いらない？
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func tapEditButton(_ sender: Any) {
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
    }

    func toggleTask() {
        setSelected(true, animated: true)
        done = !done
        setSelected(false, animated: true)
    }

    private func check() {
        if let attributedText = textField.attributedText {
            let stringAttributes: [NSAttributedStringKey: Any] = [
                .font: UIFont.systemFont(ofSize: 17, weight: .black),
                .strikethroughStyle: 2,
                .foregroundColor: UIColor.lightGray
            ]
            let string = NSAttributedString(string: attributedText.string, attributes: stringAttributes)
            textField.attributedText = string
        }

        iconView.image = doneImage
        iconView.tintColor = UIColor.lightGray
    }

    private func uncheck() {
        if let attributedText = textField.attributedText {
            let stringAttributes: [NSAttributedStringKey: Any] = [
                .font: UIFont.systemFont(ofSize: 17, weight: .black)
            ]
            let string = NSAttributedString(string: attributedText.string, attributes: stringAttributes)
            textField.attributedText = string
        }

        iconView.image = boxImage
        iconView.tintColor = UIColor.gray
    }
}

extension TaskCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.isUserInteractionEnabled = false
        textField.resignFirstResponder()
        return true
    }
}
