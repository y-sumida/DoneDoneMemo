import Foundation
import UserNotifications
import RxSwift

class AppSettingsViewModel {
    let allowPush = Variable<Bool>(false)

    init() {
        checkPush()
    }

    func checkPush() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { [weak self] in
            self?.allowPush.value = $0.authorizationStatus == .authorized
        })
    }

    func numberOfSections() -> Int {
        return 2
    }

    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 1: return 2
        default: return 1
        }
    }

    func title(for index: IndexPath) -> String {
        switch (index.section, index.row) {
        case (0, 0):
            return "Alarm"
        case (1, 0):
            return "version"
        case (1, 1):
            return "License"
        default:
            return ""
        }
    }

    func titleForHeaderInsection(section: Int) -> String? {
        switch section {
        case 0: return "Settings"
        case 1: return "DonPad"
        default: return nil
        }
    }
}
