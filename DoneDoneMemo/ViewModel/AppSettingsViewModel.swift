import Foundation

struct AppSettingsViewModel {
    // TODO バージョン読み込み
    // TODO 他のセクション

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRowsInSection(section: Int) -> Int {
        return 2
    }

    func title(for index: IndexPath) -> String {
        switch (index.section, index.row) {
        case (0, 0):
            return "バージョン"
        case (0, 1):
            return "OSSライセンス"
        default:
            return ""
        }
    }
}
