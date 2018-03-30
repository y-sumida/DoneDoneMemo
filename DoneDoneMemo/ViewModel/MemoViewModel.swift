struct MemoViewModel {
    private var memo: Memo!

    var title: String {
        return memo.title
    }

    var numberOfTasks: Int {
        return memo.tasks.count
    }

    init(from memo: Memo) {
        self.memo = memo
    }

    func task(at index: Int) -> Task? {
        guard index < numberOfTasks else { return nil }
        return memo.tasks[numberOfTasks - index - 1]
    }

    // TODO: CRUD処理
    func addTask(title: String) {
       memo.addTask(title: title)
    }

    func deleteTask(at index: Int) {
        guard index < numberOfTasks else { return }
        memo.tasks[index].delete()
    }

    func toggleDone(at index: Int) {
        memo.toggleDone(at: index)
    }
}
