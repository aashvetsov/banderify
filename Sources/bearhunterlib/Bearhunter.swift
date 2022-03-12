import Foundation

public enum Bearhunter {}

public extension Bearhunter {

    static func scan(_ path: String?) throws -> ComponentsSet {
        guard let path = path else { throw Error.missingSourceDirectory }
        guard path.isExistingDirectory else { throw Error.notExistingSourceDirectory }

        let files = locateConfigFiles(at: path)
        let components = scanComponents(at: files)

        return components
    }
}

fileprivate extension Bearhunter {

    static func locateConfigFiles(at path: String) -> ConfigFilesSet {
        print("***************** BEARHUNTER STEP1 ******************".level1)
        print("Started analysis of directory: \(path)".level2)

        let files = Set(
            DMType.allCases
                .map { ConfigLocator(directory: path, type: $0) }
                .flatMap(\.configFiles)
        )

        print("Detected files potentially containing dependencies:".level2)
        print("\(files.setmap(\.identity).list)")

        return files
    }

    static func scanComponents(at files: ConfigFilesSet) -> ComponentsSet {
        print("***************** BEARHUNTER STEP2 ******************".level1)
        print("Started analysis of config files".level2)

        let components = Set(
            files.flatMap { ConfigScanner(file: $0).components }
        )

        print("Detected dependencies:".level2)
        print("\(components.setmap(\.url).list.link)")

        return components
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
