//
//  ViewController.swift
//  DoneDoneMemo
//
//  Created by Yuki Sumida on 2018/02/26.
//  Copyright © 2018年 Yuki Sumida. All rights reserved.
//

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
