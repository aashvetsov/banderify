import CarthageKit
import Foundation

enum CarthageScanningStrategy {}

extension CarthageScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories? {
        guard
            let repositories = file.cartfile?.dependencies
                .map(\.key)
                .compactMap(Repository.init)
                .set()
        else {
            return nil
        }

        return repositories
    }
}

fileprivate extension ConfigFile {

    var cartfile: Cartfile? {
        let fileUrl = url.fileURL
        switch Cartfile.from(file: fileUrl) {
        case .success(let cartfile): return cartfile
        default: return nil
        }
    }
}

fileprivate extension Repository {

    init?(_ dependency: CarthageKit.Dependency) {
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
        guard let dependencyName = dependencyName else { return nil }
        self.init(name: dependencyName, url: dependencyUrl)
    }
}

fileprivate extension URL {

    var fileURL: URL {
        guard
            !absoluteString.contains(Conststants.fileScheme),
            let url = URL(string: "\(Conststants.fileScheme)\(absoluteString)")
        else {
            return self
        }
        return url
    }

    enum Conststants {
        static let fileScheme = "file://"
    }
}
