struct MemoListViewModel {
    private let repository = MemoRipository()
    var memos: [Memo] = []

    init() {
        memos = repository.fetch()
    }
    // TODO: CRUD処理
}
