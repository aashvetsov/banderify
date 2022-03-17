import PathKit
import XcodeProj

enum XcodeProjScanningStrategy {}

extension XcodeProjScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories? {
        guard
            let project = try? XcodeProj(path: Path(file.url.absoluteString)),
            let repositories = project.repositories
        else {
            return nil
        }

        return repositories
    }
}

fileprivate extension XcodeProj {

    var repositories: Repositories? {
        pbxproj.projects
            .flatMap(\.packages)
            .compactMap(Repository.init)
            .set()
    }
}

fileprivate extension Repository {

    init?(_ package: XCRemoteSwiftPackageReference) {
        guard let name = package.name else { return nil }
        self.init(name: name, url: package.repositoryURL)
    }
}
