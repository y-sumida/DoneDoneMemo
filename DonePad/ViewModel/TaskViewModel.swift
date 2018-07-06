import Foundation
import RxSwift

struct TaskViewModel {
    private var task: Task!

    var title: Variable<String> = Variable("")

    var numberOfSections: Int {
        return 2 // タイトル、期限
    }

    init(from task: Task) {
        self.task = task
        title.value = task.title
    }

    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        default: return 1 // とりあえず
        }
    }
}
