import Foundation

struct ConfigFile: Identifiable, Hashable {

    let id: String

    let name: String
    let directory: String
    let url: URL

    let type: DMType

    init?(
        id: String? = nil,
        name: String,
        directory: String,
        type: DMType
    ) {
        self.id = id ?? name

        self.type = type
        if  let url = URL(string: "\(directory)/\(name)"),
            let name = url.fileName,
            let directory = url.directory {
            self.name = name
            self.directory = directory
            self.url = url
        } else {
            return nil
        }
    }
}

typealias ConfigFiles = Set<ConfigFile>
