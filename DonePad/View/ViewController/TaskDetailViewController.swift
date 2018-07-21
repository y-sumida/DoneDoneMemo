import UIKit
import Instantiate
import InstantiateStandard
import RxSwift

final class TaskDetailViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = Task

    @IBOutlet private weak var tableView: UITableView!

    private var viewModel: TaskViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        setupNavigationItem()
        tableView.dataSource = self
        tableView.registerNib(type: InputTextCell.self)
        tableView.registerNib(type: AlarmPickerCell.self)

        // キーボード外をタップしたときにキーボードを閉じる
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.subscribe { [unowned self] _ in
            self.view.endEditing(true)
            }.disposed(by: disposeBag)
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func save() {
        viewModel.updateTask()
        close()
    }

    private func setupNavigationItem() {
        navigationItem.title = "詳細"
        let closeButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.close))
        closeButton.tintColor = UIColor.black
        closeButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .light)], for: .normal)
        navigationItem.leftBarButtonItem = closeButton
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.save))
        saveButton.tintColor = UIColor.black
        saveButton.setTitleTextAttributes([.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 17, weight: .light)], for: .disabled)
        navigationItem.rightBarButtonItem = saveButton
    }
}

extension TaskDetailViewController: StoryboardInstantiatable {
    func inject(_ dependency: Task) {
        viewModel = TaskViewModel(from: dependency)
    }
}

extension TaskDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = InputTextCell.dequeue(from: tableView, for: indexPath, with: viewModel.title)
            return cell
        case 1:
            let cell = AlarmPickerCell.dequeue(from: tableView, for: indexPath, with: viewModel.deadline)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
