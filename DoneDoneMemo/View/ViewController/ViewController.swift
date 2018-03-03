import UIKit

class ViewController: UIViewController {
    private var viewModel = MemoListViewModel()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .black),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        navigationItem.title = "メモ一覧"

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.memos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        if indexPath.row < viewModel.memos.count {
            cell.textLabel?.text = viewModel.memos[indexPath.row].title
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.memos.count else { return }
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemoViewController") as? MemoViewController {
            vc.viewModel = MemoViewModel(memo: viewModel.memos[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
