//
//  MemoListViewModel.swift
//  DoneDoneMemo
//
//  Created by Yuki Sumida on 2018/03/01.
//  Copyright © 2018年 Yuki Sumida. All rights reserved.
//

struct MemoListViewModel {
    var memos: [Memo] = []

    init() {
        // TODO: MemoRepositoryからFetchする
        for i in 0...100 {
            memos.append(Memo(title: "Memo \(i)", tasks: []))
        }
    }
    // TODO: CRUD処理
}

struct Memo {
    var title: String
    var tasks: [Task]
}

struct Task {
    var title: String
    var done: Bool
}
