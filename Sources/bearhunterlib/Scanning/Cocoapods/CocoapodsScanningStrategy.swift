import Foundation

enum CocoapodsScanningStrategy {}

extension CocoapodsScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        guard
            let executable = PodExecutable.installed,
            let jsonOutput = Shell.run(
                command: executable,
                with: PodExecutable.dumpArgs + [file.name],
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

        // TODO: get urls for repositories

        return repositories
    }
}

fileprivate extension CocoapodsScanningStrategy {

    enum PodExecutable: String, CaseIterable {
        case gem = "/usr/local/bin/pod"
        case homebrew = "/opt/homebrew/bin/pod"

        static let dumpArgs = ["ipc", "podfile-json"]

        static var installed: String? {
            allCases
                .map(\.rawValue)
                .first(where: FileManager.default.fileExists)
        }
    }
}

fileprivate extension CocoapodsScanningStrategy.Pod.Dependency {

    var repositories: [Repository] {
        map { Repository(name: $0.key, version: $0.value.first) }
    }
}
