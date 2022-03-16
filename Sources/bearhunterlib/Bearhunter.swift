import Foundation

public enum Bearhunter {}

public extension Bearhunter {

    static func scan(_ path: String?) throws -> Repositories {
        guard let path = path else { throw Error.missingSourceDirectory }
        guard path.isExistingDirectory else { throw Error.notExistingSourceDirectory }

        let files = locateConfigFiles(at: path)
        let repositories = scanRepositories(at: files)

        return repositories
    }
}

fileprivate extension Bearhunter {

    static func locateConfigFiles(at path: String) -> ConfigFiles {
        print("Started analysis of directory: \(path)".loginfo)

        let files = Set(
            DMType.allCases
                .map { ConfigLocator(directory: path, type: $0) }
                .flatMap(\.configFiles)
        )

        print("Detected files potentially containing dependencies:".loginfo)
        print("\(files.map(\.identity).multilined)")

        return files
    }

    static func scanRepositories(at files: ConfigFiles) -> Repositories {
        print("Started analysis of config files".loginfo)

        let repositories = Set(
            files.flatMap { ConfigScanner(file: $0).repositories }
        )

        print("Detected dependencies:".loginfo)
        print("\(repositories.map(\.url).multilined.link)")

        return repositories
    }
}

fileprivate extension String {

    var isExistingDirectory: Bool {
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
