import Foundation
import RealmSwift

class MemoRipository {
    private let realm = try! Realm()

    init() {
    }

    func fetch() -> [Memo] {
        let memos =  realm.objects(Memo.self)
        return memos.map { Memo.init(value: $0) }
    }

    func createMemo() -> Memo {
        let memo = Memo()
        memo.title = "無題のメモ"
        try! realm.write {
            realm.add(memo, update: true)
        }
        return memo
    }

    func findMemoById(_ id: String) -> Memo? {
        return realm.objects(Memo.self).filter("id = %@", id).first
    }
}

class Memo: RealmSwift.Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var title: String = ""
    let tasks = List<Task>()
    let deletedTasks = List<Task>()

    override static func primaryKey() -> String? {
        return "id"
    }

    func toggleDone(at index: Int) {
        guard index < tasks.count else { return }
        let task = tasks[index]
        let realm = try! Realm()
        try! realm.write {
            task.done = !task.done
            task.doneAt = Date()
            realm.add(task)
        }
    }

    func addTask(title: String) {
        let task = Task()
        task.title = title

        let realm = try! Realm()
        try! realm.write {
            self.tasks.insert(task, at: 0)
            realm.add(self, update: true)
        }
    }

    func editTask(at index: Int, title: String) {
        guard index < tasks.count else { return }
        let task = tasks[index]
        let realm = try! Realm()
        try! realm.write {
            task.title = title
            task.updatedAt = Date()
            realm.add(task)
        }
    }

    func deleteTask(at index: Int) {
        guard index < tasks.count else { return }
        let task = tasks[index]
        let realm = try! Realm()
        try! realm.write {
            tasks.remove(at: index)
            task.active = false
            task.deletedAt = Date()
            deletedTasks.append(task)
            realm.add(self, update: true)
        }
    }
}

class Task: RealmSwift.Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var active: Bool = true
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var updatedAt: Date = Date()
    @objc dynamic var deletedAt: Date = Date()
    @objc dynamic var doneAt: Date = Date()

    override static func primaryKey() -> String? {
        return "id"
    }
}
