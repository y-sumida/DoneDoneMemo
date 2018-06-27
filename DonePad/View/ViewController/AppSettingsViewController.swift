import UIKit
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa
import GoogleMobileAds

final class AppSettingsViewController: UIViewController {
    // StoryboardInstantiatable
    typealias Dependency = Void

    @IBOutlet weak var bannerView: GADBannerView!
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

        // TestAd
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectRows()

        NotificationCenter.default.rx.notification(.UIApplicationDidBecomeActive, object: nil)
            .subscribe(onNext: {[weak self] notification in
                self?.enterForeground(notification)
            }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func bind() {
        viewModel.allowPush.asObservable()
            .bind(onNext: {[weak self] _ in
                DispatchQueue.main.async(execute: {
                    self?.tableView.reloadData()
                })
            }).disposed(by: disposeBag)
    }

    private func deselectRows() {
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }

    private func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide.bottomAnchor,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func enterForeground(_ notify: Notification) {
        deselectRows()
        viewModel.checkPush()
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
        guard let type = viewModel.dataType(for: indexPath) else { return UITableViewCell() }
        switch type {
        case .alam:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = viewModel.title(for: indexPath)
            cell.detailTextLabel?.text = viewModel.allowPush.value ? "On" : "Off"
            return cell
        case .version:
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
            let cell = AppSettingsVersionCell.dequeue(from: tableView, for: indexPath, with: version)
            return cell
        case .license:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = viewModel.title(for: indexPath)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}

extension AppSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = viewModel.dataType(for: indexPath) else { return }
        switch type {
        case .alam:
            guard let url = URL(string: "App-Prefs:root=NOTIFICATIONS_ID&path=" + (Bundle.main.bundleIdentifier ?? "")) else { return }
            UIApplication.shared.open(url)
        case .version:
            break
        case .license:
            let vc = LicensesViewController(with: Void())
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
            backButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .light)], for: .normal)
            backButton.tintColor = UIColor.black
            navigationItem.backBarButtonItem = backButton
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
