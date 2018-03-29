import UIKit
import Instantiate
import InstantiateStandard

final class MemoViewController: UIViewController {
    private var content: MemoContentViewController!
    private var viewModel: MemoViewModel!
    private var accessoryView: KeyboardTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.title

        content = MemoContentViewController(with: viewModel)
        addChildViewController(content)
        content.view.frame = self.view.bounds
        self.view.addSubview(content.view)
        content.didMove(toParentViewController: self)

        accessoryView = KeyboardTextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        accessoryView.textField.delegate = self
    }

    override var inputAccessoryView: UIView? {
        return accessoryView
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
}

extension MemoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO リロード
        if let title = textField.text {
            viewModel.addTask(title: title)
        }
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
}

extension MemoViewController: StoryboardInstantiatable {
    func inject(_ dependency: MemoViewModel) {
        self.viewModel = dependency
    }
}
