import Foundation
struct ConfigLocator {

    let directory: String
    let type: DMType

    var configFiles: ConfigFiles? {
        guard
            let descriptor = FileDescriptor(string: type.rawValue),
            let files: ConfigFiles = FileFinder.existingFiles(by: descriptor, at: directory)?
                .compactMap({
                    guard let url = URL(string: "\(directory)/\($0)") else { return nil }
                    return ConfigFile(id: $0, url: url, type: type)
                })
                .set()
        else {
            return nil
        }

        return files
    }
}
