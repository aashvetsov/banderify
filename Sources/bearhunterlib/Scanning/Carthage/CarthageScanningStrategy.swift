import CarthageKit
import Foundation

enum CarthageScanningStrategy {}

extension CarthageScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        let fileUrl = file.url.prefixedFileScheme
        var cartfile: Cartfile?
        switch Cartfile.from(file: fileUrl) {
        case .success(let result): cartfile = result
        default: break
        }
        guard let cartfile = cartfile else { return [] }

        let repositories = cartfile.dependencies
            .map(\.key)
            .compactMap(repository(from:))

        return Set(repositories)
    }
}

fileprivate extension CarthageScanningStrategy {

    static func repository(from dependency: Dependency) -> Repository? {
        var dependencyName, dependencyUrl: String?
        switch dependency {
        case let .gitHub(server, repository):
            dependencyName = repository.name
            dependencyUrl = "\(server.url.absoluteString)/\(repository.owner)/\(repository.name)"
        case let .git(gitURL):
            dependencyName = URL(string: gitURL.urlString)?.lastPathComponent.components(separatedBy: ".").first
            dependencyUrl = gitURL.urlString
        default:
            return nil
        }
        guard let url = dependencyUrl else { return nil }
        return Repository(name: dependencyName, url: url)
    }
}
