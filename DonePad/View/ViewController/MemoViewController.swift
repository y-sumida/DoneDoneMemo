import UIKit
import RxSwift
import RxCocoa

final class MemoViewController: UIViewController {
    private var viewModel: MemoViewModel! {
        didSet {
            navigationItem.title = viewModel.title
            saveMemoId()
            tableView.reloadData()
        }
    }
    var _inputAccessoryView: UIView!
    private var accessoryView: KeyboardTextView!
    private let disposeBag = DisposeBag()

    private var editingIndex: IndexPath?

    let animator = ZoomInAnimator()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var shadowView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        shadowView.isHidden = true
        // キーボード外をタップしたときにキーボードを閉じる
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        tapGesture.rx.event.subscribe { [unowned self] _ in
            self.accessoryView.hideKeyboard()
            }.disposed(by: disposeBag)
        shadowView.addGestureRecognizer(tapGesture)
        // 下スワイプでキーボードを閉じる
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.direction = .down
        swipeGesture.rx.event.subscribe { [unowned self] _ in
            self.accessoryView.hideKeyboard()
            }.disposed(by: disposeBag)
        shadowView.addGestureRecognizer(swipeGesture)

        let defaults = UserDefaults.standard
        if let id = defaults.value(forKey: "memoId") as? String {
            viewModel = MemoViewModel(from: id)
        } else {
            viewModel = MemoViewModel(from: "")
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset.bottom = 60

        tableView.registerNib(type: TaskCell.self)

        accessoryView = KeyboardTextView(with: Void())
        accessoryView.delegate = self
        accessoryView.addAction = {[unowned self] title, deadline in
            self.addTask(title: title, deadline: deadline)
            self.accessoryView.hideKeyboard()
        }

        setupNavigationItems()

        bindKeyboardEvent()

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showEditMenu))
        tableView.addGestureRecognizer(longPressRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editingIndex = nil
        viewModel.reload()
        navigationItem.title = viewModel.title
        if viewModel.numberOfTasks == 0 {
            accessoryView.showKeyboard()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        accessoryView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // https://stackoverflow.com/questions/46282987/iphone-x-how-to-handle-view-controller-inputaccessoryview
    override var inputAccessoryView: UIView? {
        if _inputAccessoryView == nil {
            _inputAccessoryView = WrapperView()
            _inputAccessoryView.backgroundColor = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)

            _inputAccessoryView.addSubview(accessoryView)
            _inputAccessoryView.autoresizingMask = .flexibleHeight
            accessoryView.translatesAutoresizingMaskIntoConstraints = false

            accessoryView.leadingAnchor.constraint(
                equalTo: _inputAccessoryView.leadingAnchor,
                constant: 0
                ).isActive = true

            accessoryView.trailingAnchor.constraint(
                equalTo: _inputAccessoryView.trailingAnchor,
                constant: 0
                ).isActive = true

            accessoryView.topAnchor.constraint(
                equalTo: _inputAccessoryView.topAnchor,
                constant: 0
                ).isActive = true

            accessoryView.bottomAnchor.constraint(
                equalTo: _inputAccessoryView.layoutMarginsGuide.bottomAnchor,
                constant: 0
                ).isActive = true
        }
        return _inputAccessoryView
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    private func saveMemoId() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "memoId")
        defaults.setValue(viewModel.memoId, forKey: "memoId")
    }

    private func clearMemoId() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "memoId")
    }

    private func addTask(title: String, deadline: Date?) {
        guard title.isNotEmpty else { return }

        tableView.beginUpdates()
        viewModel.addTask(title: title, deadline: deadline)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        tableView.reloadSections([0], with: .automatic)
        tableView.endUpdates()
    }

    private func editTask(at indexPath: IndexPath, title: String) {
        guard title.isNotEmpty else { return }
        viewModel.editTask(at: indexPath.row, title: title)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    @objc private func tapTrashButton() {
        accessoryView.isHidden = true
        accessoryView.hideKeyboard()

        let alert = UIAlertController(title: "このメモを削除しますか？", message: "この操作は取り消せません", preferredStyle: .alert)
        let deleteAll = UIAlertAction(title: "削除する", style: .destructive, handler: {[unowned self] _ in
            self.viewModel.delete()
            self.clearMemoId()
            self.showMemoList()
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: {[unowned self] _ in
           self.accessoryView.isHidden = false
        })
        alert.addAction(deleteAll)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    @objc private func showMemoList() {
        accessoryView.isHidden = true
        let vc = MemoCollectionViewController(with: { memo in
            self.viewModel = memo
        })
        accessoryView.hideKeyboard()
        let navi = UINavigationController(rootViewController: vc)
        navi.transitioningDelegate = self
        navigationController?.present(navi, animated: true, completion: nil)
    }

    @objc private func showSettings() {
        accessoryView.isHidden = true
        accessoryView.hideKeyboard()

        let vm = MemoSettingsViewModel(from: viewModel.memoId)
        let vc = MemoSettingsViewController(with: vm)
        let navi = UINavigationController(rootViewController: vc)
        navigationController?.present(navi, animated: true, completion: nil)
    }

    @objc private func showEditMenu(sender: UILongPressGestureRecognizer) {
        if case .began = sender.state {
            let point = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point),
                let task = viewModel.task(at: indexPath.row) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
                editingIndex = indexPath
                accessoryView.addAction = {[unowned self] title, _ in
                    self.editTask(at: indexPath, title: title)
                    self.accessoryView.hideKeyboard()
                }
                accessoryView.showKeyboard(title: task.title, deadline: task.deadline)
            }
        }
    }

    private func setupNavigationItems() {
        var barItems: [UIBarButtonItem] = []

        let trashButton = UIButton(type: .system)
        trashButton.addTarget(self, action: #selector(self.tapTrashButton), for: .touchUpInside)
        trashButton.setImage(UIImage(named: "ic_delete")?.withRenderingMode(.alwaysTemplate), for: .normal)
        trashButton.tintColor = UIColor.black
        let trash = UIBarButtonItem(customView: trashButton)
        barItems.append(trash)

        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 11
        barItems.append(space)

        let settingButton = UIButton(type: .system)
        settingButton.addTarget(self, action: #selector(self.showSettings), for: .touchUpInside)
        settingButton.setImage(UIImage(named: "ic_setting")?.withRenderingMode(.alwaysTemplate), for: .normal)
        settingButton.tintColor = UIColor.black
        let setting = UIBarButtonItem(customView: settingButton)
        barItems.append(setting)
        navigationItem.rightBarButtonItems = barItems
    }

    @IBAction func tapListButton(_ sender: Any) {
        showMemoList()
    }
}

extension MemoViewController {
    func bindKeyboardEvent() {
        NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillShow, object: nil)
            .bind { [unowned self] notification in
                self.keyboardWillShow(notification)
            }
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillHide, object: nil)
            .bind { [unowned self] notification in
                self.keyboardWillHide(notification)
            }
            .disposed(by: disposeBag)
    }

    func keyboardWillShow(_ notification: Notification) {
        if let indexPath = editingIndex,
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue,
            let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {

            UIView.beginAnimations("ResizeForKeyboard", context: nil)
            UIView.setAnimationDuration(animationDuration)

            tableView.contentInset.bottom = keyboardFrame.height
            tableView.scrollIndicatorInsets.bottom = keyboardFrame.height
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)

            UIView.commitAnimations()
        }
    }

    func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset.bottom = 60
        tableView.scrollIndicatorInsets.bottom = 60
        accessoryView.addAction = {[unowned self] title, deadline in
            self.addTask(title: title, deadline: deadline)
            self.accessoryView.hideKeyboard()
        }
    }
}

extension MemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTasks
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let task = viewModel.task(at: indexPath.row) else { return UITableViewCell() }
        let cell = TaskCell.dequeue(from: tableView, for: indexPath, with: task)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard viewModel.numberOfTasks == 0 else { return nil }
        return EmptyView(with: "まだタスクがありません。")
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard viewModel.numberOfTasks == 0 else { return .leastNonzeroMagnitude }
        return 100
    }
}

extension MemoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
        accessoryView.hideKeyboard()
        cell.toggleTask()
        viewModel.toggleDone(at: indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        accessoryView.hideKeyboard()
        return "削除"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, viewModel.numberOfTasks > indexPath.row {
            tableView.beginUpdates()
            viewModel.deleteTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

extension MemoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        accessoryView.invalidateIntrinsicContentSize()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        shadowView.isHidden = false
        guard viewModel.numberOfTasks > 0, editingIndex == nil else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        shadowView.isHidden = true
        textView.text = ""
        resetEditing()
    }

    private func resetEditing() {
        editingIndex = nil
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }
}

extension MemoViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

class WrapperView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
}
