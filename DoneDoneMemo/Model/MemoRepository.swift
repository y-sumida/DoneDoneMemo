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

            let task = Task()
            task.id = i
            task.title = "Task \(i)"

            memo.tasks.append(task)

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