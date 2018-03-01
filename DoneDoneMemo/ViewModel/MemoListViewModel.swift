//
//  MemoListViewModel.swift
//  DoneDoneMemo
//
//  Created by Yuki Sumida on 2018/03/01.
//  Copyright © 2018年 Yuki Sumida. All rights reserved.
//

struct MemoListViewModel {
    private let repository = MemoRipository()
    var memos: [Memo] = []

    init() {
        memos = repository.fetch()
    }
    // TODO: CRUD処理
}
