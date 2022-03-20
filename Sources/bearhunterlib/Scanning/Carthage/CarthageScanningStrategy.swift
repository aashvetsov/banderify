import CarthageKit
import Foundation

enum CarthageScanningStrategy {}

extension CarthageScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories? {
        guard
            let cartfile = file.cartfile,
            let repositories = cartfile.repositories
        else {
            return nil
        }

        return repositories
    }
}

fileprivate extension ConfigFile {

    var cartfile: Cartfile? {
        switch Cartfile.from(file: url.fileURL) {
        case .success(let cartfile): return cartfile
        default: return nil
        }
    }
}

fileprivate extension Cartfile {

    var repositories: Repositories? {
        dependencies
            .map(\.key)
            .compactMap(Repository.init)
            .set()
    }
}

fileprivate extension Repository {

    init?(_ dependency: CarthageKit.Dependency) {
        var name, url: String?
        switch dependency {
        case let .gitHub(server, repository):
            name = repository.name
            url = "\(server.url.absoluteString)/\(repository.owner)/\(repository.name)"
        case let .git(gitURL):
            name = URL(string: gitURL.urlString)?.fileName?.components(separatedBy: ".").first
            url = gitURL.urlString
        default:
            return nil
        }
        guard let name = name, let url = url else { return nil }
        self.init(name: name, url: url)
    }
}
