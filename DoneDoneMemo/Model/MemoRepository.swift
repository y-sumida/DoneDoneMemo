//
//  MemoRepository.swift
//  DoneDoneMemo
//
//  Created by Yuki Sumida on 2018/03/01.
//  Copyright © 2018年 Yuki Sumida. All rights reserved.
//
import Foundation
import RealmSwift

class MemoRipository {
    private let realm = try! Realm()

    init() {
        // dummy data
        for i in 0...100 {
            let memo = Memo()
            memo.id = i
            memo.title = "Memo \(i)"

            try! realm.write {
                realm.add(memo, update: true)
            }
        }
    }

    func fetch() -> [Memo] {
        let memos =  realm.objects(Memo.self)
        return memos.map { Memo.init(value: $0) }
    }
}

class Memo: RealmSwift.Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    let tasks = List<Task>()

    override static func primaryKey() -> String? {
        return "id"
    }
}

class Task: RealmSwift.Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false

    let memo = LinkingObjects(fromType: Memo.self, property: "tasks")

    override static func primaryKey() -> String? {
        return "id"
    }
}
