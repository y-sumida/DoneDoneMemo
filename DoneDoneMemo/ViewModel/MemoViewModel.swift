struct MemoViewModel {
    // TODO private化する
    var memo: Memo!

    var numberOfTasks: Int {
        return memo.tasks.count
    }

    init(from memo: Memo) {
        self.memo = memo
    }
    // TODO: CRUD処理

    func deleteTask(at: Int) {
        // TODO id指定したい
        memo.tasks.remove(at: at)
    }
}
