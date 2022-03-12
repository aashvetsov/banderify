import Foundation

struct ConfigFile: Hashable {

    let identity: String
    let name: String
    let directory: String
    let type: DMType

    init(
        name: String,
        directory: String,
        type: DMType
    ) {
        self.identity = name
        self.type = type
        let url = URL(string: "\(directory)/\(name)")
        self.name = url?.lastPathComponent ?? name
        self.directory = url?.deletingLastPathComponent().absoluteString ?? directory
        self.url = url
    }

    var url: URL?
}

typealias ConfigFiles = Set<ConfigFile>
