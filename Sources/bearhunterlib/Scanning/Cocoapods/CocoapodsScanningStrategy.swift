import Foundation

enum CocoapodsScanningStrategy {}

extension CocoapodsScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories? {
        guard
            let json = PodExecutable.podsJSONDump(for: file.url),
            let pods = decode(Pods.self, from: json, strategy: .convertFromSnakeCase),
            let repositories = pods.repositories
        else {
            return nil
        }

        return repositories
    }
}

fileprivate extension Pods {

    var repositories: Repositories? {
        dependencies?
            .compactMap(Repository.init)
            .set()
    }
}

fileprivate extension Repository {

    typealias Dependency = Pods.Dependency

    init?(_ dependency: Dependency) {
        guard let name = dependency.name else { return nil }
        self.init(name: name, url: dependency.url, version: dependency.version)
    }
}
