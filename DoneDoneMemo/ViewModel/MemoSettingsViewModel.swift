import RxSwift

struct MemoSettingsViewModel {
    private var memo: Memo?
    var title: Variable<String> = Variable("")

    init(from id: String) {
        if let memo = MemoRipository().findMemoById(id) {
            self.memo = memo
            title.value = memo.title
        }
    }
}
