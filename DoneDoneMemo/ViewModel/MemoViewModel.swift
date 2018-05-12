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
        } else {
            memo = MemoRipository().createMemo()
        }
    }

    func task(at index: Int) -> Task? {
        guard index < numberOfTasks else { return nil }
        return memo.tasks[index]
    }

    // TODO: CRUD処理
    func addTask(title: String) {
       memo.addTask(title: title)
    }

    func editTask(at index: Int, title: String) {
        memo.editTask(at: index, title: title)
    }

    func deleteTask(at index: Int) {
        memo.deleteTask(at: index)
    }

    func toggleDone(at index: Int) {
        memo.toggleDone(at: index)
    }
}
