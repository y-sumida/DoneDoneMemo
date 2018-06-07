struct Licenses: Codable {
    var items: [License]

    private enum CodingKeys: String, CodingKey {
        case items = "PreferenceSpecifiers"
    }
}

struct License: Codable {
    var title: String
    var file: String

    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case file = "File"
    }
}

struct LicenseDetails: Codable {
    var items: [LicenseDetail]

    private enum CodingKeys: String, CodingKey {
        case items = "PreferenceSpecifiers"
    }
}

struct LicenseDetail: Codable {
    var body: String

    private enum CodingKeys: String, CodingKey {
        case body = "FooterText"
    }
}
