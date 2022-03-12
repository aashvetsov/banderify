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

        let repositories: [Repository] = project.pbxproj.projects
            .flatMap(\.packages)
            .compactMap {
                guard let url = $0.repositoryURL else { return nil }
                return Repository(name: $0.name, url: url)
            }
        return Set(repositories)
    }
}
