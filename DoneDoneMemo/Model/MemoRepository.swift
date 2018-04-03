import Foundation
import RealmSwift

class MemoRipository {
    private let realm = try! Realm()

    init() {
        let memos =  realm.objects(Memo.self)
        try! realm.write {
            realm.delete(memos)
        }

        // dummy data
        for i in 0...10 {
            let memo = Memo()
            memo.title = "Memo \(i)"

            for j in 0...100 {
                let task = Task()
                task.title = "Task \(j)"
                memo.tasks.insert(task, at: 0)
            }

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
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var title: String = ""
    let tasks = List<Task>()

    override static func primaryKey() -> String? {
        return "id"
    }

    func toggleDone(at index: Int) {
        guard index < tasks.count else { return }
        let task = tasks[index]
        let realm = try! Realm()
        try! realm.write {
            task.done = !task.done
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

    func deleteTask(at index: Int) {
        guard index < tasks.count else { return }
        let task = tasks[index]
        let realm = try! Realm()
        try! realm.write {
            tasks.remove(at: index)
            realm.delete(task)
        }
    }
}

class Task: RealmSwift.Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var active: Bool = true

    let memo = LinkingObjects(fromType: Memo.self, property: "tasks")

    override static func primaryKey() -> String? {
        return "id"
    }

    func delete() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
}
