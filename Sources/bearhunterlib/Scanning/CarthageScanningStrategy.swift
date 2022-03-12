import CarthageKit
import Foundation

enum CarthageScanningStrategy {}

extension CarthageScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> ComponentsSet {
        guard let fileUrl = file.url?.prefixedFileScheme else { return [] }

        var cartfile: Cartfile?
        switch Cartfile.from(file: fileUrl) {
        case .success(let result): cartfile = result
        default: break
        }
        guard let cartfile = cartfile else { return [] }

        let components: [Component] = cartfile.dependencies
            .map(\.key)
            .compactMap(component(from:))

        return Set(components)
    }
}

fileprivate extension CarthageScanningStrategy {

    static func component(from dependency: Dependency) -> Component? {
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
        return Component(name: dependencyName, url: url)
    }
}

fileprivate extension URL {

    var prefixedFileScheme: URL? {
        URL(string: "file://\(absoluteString)")
    }
}
