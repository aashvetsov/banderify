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
            .flatMap(\.repositories)
            .set()

        return repositories
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

fileprivate extension CocoapodsScanningStrategy.Pod.Dependency {

    var repositories: Repositories {
        compactMap { Repository(name: $0.key, version: $0.value.first) }.set()
    }
}
