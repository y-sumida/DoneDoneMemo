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
        case 0: return 2
        default: return 1
        }
    }

    func title(for index: IndexPath) -> String {
        switch (index.section, index.row) {
        case (0, 0):
            return "version"
        case (0, 1):
            return "License"
        case (1, 0):
            return "Alarm"
        default:
            return ""
        }
    }

    func titleForHeaderInsection(section: Int) -> String? {
        switch section {
        case 0: return "DonPad"
        case 1: return "Settings"
        default: return nil
        }
    }
}
