import PathKit
import XcodeProj

enum XcodeProjScanningStrategy {}

extension XcodeProjScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        guard
            let url = file.url?.absoluteString,
            case let path = Path(url),
            let project = try? XcodeProj(path: path)
        else {
            return []
        }

        let repositories = project.pbxproj.projects
            .flatMap(\.packages)
            .compactMap(repository(from:))
        
        return Set(repositories)
    }
}

fileprivate extension XcodeProjScanningStrategy {

    static func repository(from package: XCRemoteSwiftPackageReference) -> Repository? {
        guard let url = package.repositoryURL else { return nil }
        return Repository(name: package.name, url: url)
    }
}
