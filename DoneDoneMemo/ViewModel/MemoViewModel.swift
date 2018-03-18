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
        return memo.tasks[index]
    }

    // TODO: CRUD処理

    func deleteTask(at: Int) {
        // TODO id指定したい
        memo.tasks.remove(at: at)
    }

    func toggleDone(at index: Int) {
        memo.toggleDone(at: index)
    }
}
