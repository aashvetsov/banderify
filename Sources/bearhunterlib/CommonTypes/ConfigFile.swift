import Foundation

struct ConfigFile: Hashable {

    let identity: String
    let name: String
    let directory: String
    let type: DMType
    let url: URL

    init?(
        name: String,
        directory: String,
        type: DMType
    ) {
        self.identity = name
        self.type = type
        if let url = URL(string: "\(directory)/\(name)") {
            self.name = url.lastPathComponent
            self.directory = url.deletingLastPathComponent().absoluteString
            self.url = url
        } else {
            return nil
        }
    }
}

typealias ConfigFiles = Set<ConfigFile>
