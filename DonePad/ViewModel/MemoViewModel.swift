import Foundation

struct MemoViewModel {
    private var memo: Memo!

    var memoId: String {
        return memo.id
    }

    var title: String {
        return memo.title
    }

    var numberOfTasks: Int {
        return memo.tasks.count
    }

    init(from memo: Memo) {
        self.memo = memo
    }

    init(from id: String) {
        if let memo = MemoRipository().findMemoById(id) {
            self.memo = memo
        } else if let memo = MemoRipository().fetch().first {
            self.memo = memo
        } else {
            memo = MemoRipository().createMemo()
        }
    }

    func task(at index: Int) -> Task? {
        guard index < numberOfTasks else { return nil }
        return memo.tasks[index]
    }

    mutating func reload() {
        let id = memo.id
        memo = MemoRipository().findMemoById(id)
    }

    // TODO: CRUD処理
    func addTask(title: String, deadline: Date?) {
       memo.addTask(title: title, deadline: deadline)
    }

    func editTask(at index: Int, title: String, deadline: Date?) {
        memo.editTask(at: index, title: title, deadline: deadline)
    }

    func deleteTask(at index: Int) {
        memo.deleteTask(at: index)
    }

    func toggleDone(at index: Int) {
        memo.toggleDone(at: index)
    }

    func delete() {
        memo.delete()
    }

    func deleteDone() {
        memo.deleteDone()
    }
}
