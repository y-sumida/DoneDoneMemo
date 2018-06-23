import UIKit
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa

final class AppSettingsViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = Void

    @IBOutlet private weak var tableView: UITableView!

    private var viewModel = AppSettingsViewModel()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.registerNib(type: AppSettingsVersionCell.self)

        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.close))
        closeButton.tintColor = UIColor.black
        closeButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .light)], for: .normal)
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.title = "アプリの設定"

        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func bind() {
        viewModel.allowPush.asObservable()
            .bind(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AppSettingsViewController: StoryboardInstantiatable {
    func inject(_ dependency: Void) {
    }
}

extension AppSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.textLabel?.text = viewModel.titleForHeaderInsection(section: section)
        headerView.contentView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
            let cell = AppSettingsVersionCell.dequeue(from: tableView, for: indexPath, with: version)
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = viewModel.title(for: indexPath)
            cell.accessoryType = .disclosureIndicator
            return cell
        case (1, 0):
            // TODO それっぽいセル作る
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = viewModel.title(for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension AppSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 1):
            let vc = LicensesViewController(with: Void())
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
            backButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .light)], for: .normal)
            backButton.tintColor = UIColor.black
            navigationItem.backBarButtonItem = backButton
            navigationController?.pushViewController(vc, animated: true)
        case (1, 0):
            guard let url = URL(string: "App-Prefs:root=NOTIFICATIONS_ID&path=" + (Bundle.main.bundleIdentifier ?? "")) else { return }
            UIApplication.shared.open(url)
        default:
            break
        }
    }
}
