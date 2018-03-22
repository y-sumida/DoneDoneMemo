import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editButton: UIButton!

    let doneImage = UIImage(named: "ic_done")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)

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

        doneButton.layer.cornerRadius = 8.0
        doneButton.layer.borderWidth = 2.0
        doneButton.layer.borderColor = UIColor.gray.cgColor
        doneButton.tintColor = UIColor.lightGray

        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func tapDoneButton(_ sender: Any) {
        // TODO ViewContoller側で検知して、VM経由でRealmを更新する
        toggleTask()
    }

    @IBAction func tapEditButton(_ sender: Any) {
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
    }

    func toggleTask() {
        done = !done
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

        doneButton.imageView?.isHidden = false
        doneButton.setImage(doneImage, for: .normal)
        doneButton.layer.borderColor = UIColor.lightGray.cgColor
    }

    private func uncheck() {
        if let attributedText = textField.attributedText {
            let stringAttributes: [NSAttributedStringKey: Any] = [
                .font: UIFont.systemFont(ofSize: 17, weight: .black)
            ]
            let string = NSAttributedString(string: attributedText.string, attributes: stringAttributes)
            textField.attributedText = string
        }

        doneButton.imageView?.isHidden = true
        doneButton.setImage(nil, for: .normal)
        doneButton.layer.borderColor = UIColor.gray.cgColor
    }
}

extension TaskCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.isUserInteractionEnabled = false
        textField.resignFirstResponder()
        return true
    }
}
