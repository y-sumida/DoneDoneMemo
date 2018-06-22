import Foundation

struct AppSettingsViewModel {
    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRowsInSection(section: Int) -> Int {
        return 2
    }

    func title(for index: IndexPath) -> String {
        switch (index.section, index.row) {
        case (0, 0):
            return "version"
        case (0, 1):
            return "License"
        default:
            return ""
        }
    }

    func titleForHeaderInsection(section: Int) -> String? {
        switch section {
        case 0: return "DonPad"
        default: return nil
        }
    }
}
