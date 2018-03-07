struct MemoViewModel {
    // TODO private化する
    var memo: Memo!

    var numberOfTasks: Int {
        return memo.tasks.count
    }

    init(memo: Memo) {
        self.memo = memo
    }
    // TODO: CRUD処理
}
