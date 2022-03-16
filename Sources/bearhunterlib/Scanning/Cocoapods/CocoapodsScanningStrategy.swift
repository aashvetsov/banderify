import Foundation

enum CocoapodsScanningStrategy {}

extension CocoapodsScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        guard
            let executable = podExecutable,
            let jsonOutput = Shell.run(
                command: executable,
                with: Command.podDumpArgs + [file.name],
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
            .map(Repository.init)

        return Set(repositories)
    }
}

fileprivate extension CocoapodsScanningStrategy {

    enum PodExecutable: String, CaseIterable {
        case gem = "/usr/local/bin/pod"
        case homebrew = "/opt/homebrew/bin/pod"
    }

    enum Command {
        static let podDumpArgs = ["ipc", "podfile-json"]
    }
}

fileprivate extension CocoapodsScanningStrategy {

    static var podExecutable: String? {
        PodExecutable.allCases
            .map(\.rawValue)
            .first(where: { FileManager.default.fileExists(atPath: $0) })
    }
}

fileprivate extension Repository {

    typealias Dependency = CocoapodsScanningStrategy.Pod.Dependency

    init(_ dependency: Dependency) {
        self.init(
            name: dependency.keys.first,
            url: "/test/url",
            version: dependency.values.first?.first
        )
    }
}
