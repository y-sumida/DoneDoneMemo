import Foundation

struct AppSettingsViewModel {
    func numberOfSections() -> Int {
        return 2
    }

    func numberOfRowsInSection(section: Int) -> Int {
        return 1
    }

    func title(for index: IndexPath) -> String {
        switch index.section {
        case 0:
            return "version"
        case 1:
            return "License"
        default:
            return ""
        }
    }
}
