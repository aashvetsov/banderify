import Foundation

public enum Bearhunter {}

public extension Bearhunter {

    static func scan(_ path: String?) throws -> Repositories? {
        guard let path = path else { throw Error.missingSourceDirectory }
        guard path.isDirectory else { throw Error.notExistingSourceDirectory }

        guard let files = locateConfigFiles(at: path) else { return nil }
        let repositories = scanRepositories(at: files)

        return repositories
    }
}

fileprivate extension Bearhunter {

    static func locateConfigFiles(at path: String) -> ConfigFiles? {
        print("Started analysis of directory: \(path)".loginfo)

        guard 
            let files = DMType.allCases
                .map({ ConfigLocator(directory: path, type: $0) })
                .flatMap(\.configFiles)
                .set()
        else {
            print("Files potentially containing dependencies were not detected".loginfo)
            return nil
        }

        print("Detected files potentially containing dependencies:".loginfo)
        print("\(files.map(\.identity).multilined)")

        return files
    }

    static func scanRepositories(at files: ConfigFiles) -> Repositories? {
        print("Started analysis of config files".loginfo)

        guard 
            let repositories = files
                .map(ConfigScanner.init)
                .flatMap(\.repositories)
                .set()
        else {
            print("Didn't detect any dependency".loginfo)
            return nil
        }

        print("Detected dependencies:".loginfo)
        print("\(repositories.compactMap(\.url).multilined.link)")

        return repositories
    }
}

fileprivate extension String {

    var isDirectory: Bool {
        var isDir: ObjCBool = false
        return FileManager.default.fileExists(
            atPath: self,
            isDirectory: &isDir
        ) ? isDir.boolValue : false
    }
}

fileprivate extension Bearhunter {

    enum Error: Swift.Error {
        case missingSourceDirectory
        case notExistingSourceDirectory
    }
}
