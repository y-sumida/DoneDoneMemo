struct MemoListViewModel {
    private let repository = MemoRipository()
    private var memos: [Memo] = []

    var numberOfMemos: Int {
        return memos.count
    }

    init() {
        memos = repository.fetch()
        if memos.isEmpty {
            let memo = repository.createMemo()
            memos.append(memo)
        }
    }

    func memo(at index: Int) -> Memo? {
        guard index < numberOfMemos else { return nil }
        return memos[index]
    }

    // TODO: CRUD処理
    mutating func deleteMemo(at index: Int) {
        // TODO ゴミ箱行きにしたい
        memos.remove(at: index)
    }

    mutating func addMemo() -> Memo {
        let memo = repository.createMemo()
        return memo
    }
}
