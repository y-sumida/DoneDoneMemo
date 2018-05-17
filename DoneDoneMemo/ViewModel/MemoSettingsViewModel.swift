struct MemoSettingsViewModel {
    private var memo: Memo?

    var title: String {
        return memo?.title ?? ""
    }

    init(from id: String) {
        if let memo = MemoRipository().findMemoById(id) {
            self.memo = memo
        }
    }
}
