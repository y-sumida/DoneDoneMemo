struct MemoListViewModel {
    private let repository = MemoRipository()
    var memos: [Memo] = [] // TODO privateにする

    var numberOfMemos: Int {
        return memos.count
    }

    init() {
        memos = repository.fetch()
    }

    // TODO: CRUD処理
    mutating func deleteMemo(at index: Int) {
        // TODO ゴミ箱行きにしたい
        memos.remove(at: index)
    }
}
