public struct Repository: Hashable {

    let name: String
    let url: String?
    let version: String?

    init?(name: String, url: String? = nil, version: String? = nil) {
        self.name = name
        self.url = url
        self.version = version
    }
}

public typealias Repositories = Set<Repository>
