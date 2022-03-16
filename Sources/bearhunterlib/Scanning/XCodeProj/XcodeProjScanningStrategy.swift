import PathKit
import XcodeProj

enum XcodeProjScanningStrategy {}

extension XcodeProjScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        let url = file.url.absoluteString
        let path = Path(url)
        guard let project = try? XcodeProj(path: path) else { return [] }

        let repositories = project.pbxproj.projects
            .flatMap(\.packages)
            .compactMap(Repository.init)

        return Set(repositories)
    }
}

fileprivate extension Repository {

    init?(_ package: XCRemoteSwiftPackageReference) {
        guard let url = package.repositoryURL else { return nil }
        self.init(name: package.name, url: url)
    }
}
