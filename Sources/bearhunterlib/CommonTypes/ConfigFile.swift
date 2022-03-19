import Foundation

struct ConfigFile: Identifiable, Hashable {

    let id: String

    let name: String
    let directory: String
    let url: URL

    let type: DMType

    init?(
        id: String? = nil,
        url: URL,
        type: DMType
    ) {
        if  let name = url.fileName,
            let directory = url.directory {
            self.name = name
            self.directory = directory
            self.id = id ?? name
        } else {
            return nil
        }
        self.url = url
        self.type = type
    }
}

typealias ConfigFiles = Set<ConfigFile>
