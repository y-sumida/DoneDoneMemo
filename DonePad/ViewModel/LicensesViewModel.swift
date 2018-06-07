import Foundation

struct LicensesViewModel {
    private var licenses: [License] = []
    private var licenseBodies: [String] = []

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
        readLicenseDetails()
    }

    var numberOfRows: Int {
        return licenses.count
    }

    func title(for row: Int) -> String {
        guard row < licenses.count else { return "" }
        return licenses[row].title
    }

    func license(for row: Int) -> String {
        guard row < licenseBodies.count else { return "" }
        return licenseBodies[row]
    }

    private mutating func readLicenseDetails() {
        licenses.forEach { license in
            guard let path: URL = Bundle.main.url(forResource: "Settings.bundle/\(license.file)", withExtension: "plist") else {
                return
            }

            if let data = try? Data(contentsOf: path) {
                let decoder = PropertyListDecoder()
                let details = try? decoder.decode(LicenseDetails.self, from: data)

                guard let items = details?.items else { return }
                licenseBodies.append((items[0].body))
            }
        }
    }
}
