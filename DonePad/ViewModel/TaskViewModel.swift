import Foundation
import RxSwift

struct TaskViewModel {
    private var task: Task!

    var title: Variable<String> = Variable("")

    init(from task: Task) {
        self.task = task
        title.value = task.title
    }
}
