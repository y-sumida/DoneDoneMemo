import Foundation
import UserNotifications
import RxSwift

enum AppSettingsType {
    case alam, version, license
}

class AppSettingsViewModel {
    var allowPush: Observable<Bool> {
        return _allowPush.asObservable()
    }

    private let _allowPush = Variable<Bool>(false)

    init() {
        checkPush()
    }

    func checkPush() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { [weak self] v in
            self?._allowPush.value = v.authorizationStatus == .authorized
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

    func dataType(for index: IndexPath) -> AppSettingsType? {
        switch (index.section, index.row) {
        case (0, 0):
            return .alam
        case (1, 0):
            return .version
        case (1, 1):
            return .license
        default:
            return nil
        }
    }
}
