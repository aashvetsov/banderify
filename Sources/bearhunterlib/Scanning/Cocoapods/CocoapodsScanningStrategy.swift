import Foundation

enum CocoapodsScanningStrategy {}

extension CocoapodsScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        guard
            let executable = podExecutable,
            let jsonOutput = Shell.run(
                command: executable,
                with: PodExecutable.podDumpArgs + [file.name],
                at: file.directory
            ),
            let pod = decode(Pod.self, from: jsonOutput, strategy: .convertFromSnakeCase),
            let targetDefinitions = pod.targetDefinitions
        else {
            return []
        }

        let repositories = targetDefinitions
            .flatMap(\.children)
            .flatMap(\.dependencies)
            .compactMap(Repository.init)

        // TODO: fill repositories with urls

        return Set(repositories)
    }
}

fileprivate extension CocoapodsScanningStrategy {

    enum PodExecutable: String, CaseIterable {
        case gem = "/usr/local/bin/pod"
        case homebrew = "/opt/homebrew/bin/pod"

        static let podDumpArgs = ["ipc", "podfile-json"]
    }

    static var podExecutable: String? {
        PodExecutable.allCases
            .map(\.rawValue)
            .first(where: { FileManager.default.fileExists(atPath: $0) })
    }
}

fileprivate extension Repository {

    typealias Dependency = CocoapodsScanningStrategy.Pod.Dependency

    init?(_ dependency: Dependency) {
        guard let name = dependency.keys.first else { return nil }
        self.init(
            name: name,
            version: dependency.values.first?.first
        )
    }
}
