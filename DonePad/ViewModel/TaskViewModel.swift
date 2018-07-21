import Foundation
import RxSwift

class TaskViewModel {
    private var task: Task!
    private let _isEdited = Variable<Bool>(false)
    private let disposeBag = DisposeBag()

    var title: Variable<String> = Variable("")
    var deadline: Variable<Date?> = Variable(nil)

    var isEdited: Observable<Bool> {
        return _isEdited.asObservable()
    }

    var numberOfSections: Int {
        return 2 // タイトル、期限
    }

    init(from task: Task) {
        self.task = task
        title.value = task.title
        deadline.value = task.deadline

        let originalTitle = task.title
        let originalDeadline = task.deadline

        Observable.combineLatest(title.asObservable(), deadline.asObservable())
            .subscribe(onNext: {[weak self] (title, deadline) in
                guard title.isNotEmpty else { return }
                self?._isEdited.value = (title != originalTitle) || (deadline != originalDeadline)
                })
            .disposed(by: disposeBag)
    }

    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        default: return 1 // とりあえず
        }
    }

    func updateTask() {
        task.update(title: title.value, deadline: deadline.value)
    }
}
