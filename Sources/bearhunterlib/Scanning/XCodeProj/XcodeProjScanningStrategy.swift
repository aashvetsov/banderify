import PathKit
import XcodeProj

enum XcodeProjScanningStrategy {}

extension XcodeProjScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories? {
        guard
            let project = try? XcodeProj(path: Path(file.url.absoluteString)),
            let repositories = project.pbxproj
                .projects
                .flatMap(\.packages)
                .compactMap(Repository.init)
                .set()
        else {
            return nil
        }

        return repositories
    }
}

fileprivate extension Repository {

    init?(_ package: XCRemoteSwiftPackageReference) {
        guard let name = package.name else { return nil }
        self.init(name: name, url: package.repositoryURL)
    }
}
