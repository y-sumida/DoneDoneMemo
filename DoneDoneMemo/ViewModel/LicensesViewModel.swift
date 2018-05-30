import Foundation

struct LicensesViewModel {
    private var licenses: [License] = []

    init() {
        guard let path: URL = Bundle.main.url(forResource: "Settings.bundle/com.mono0926.LicensePlist", withExtension: "plist") else {
            return
        }

        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            let licenses = try? decoder.decode(Licenses.self, from: data)

            if let items = licenses?.items {
                self.licenses = items
            }
        }
    }

    var numberOfRows: Int {
        return 2
    }

    func title(for row: Int) -> String {
        guard row < licenses.count else { return "" }
        return licenses[row].title
    }
}
