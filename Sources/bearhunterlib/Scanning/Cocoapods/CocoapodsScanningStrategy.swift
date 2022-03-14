import Foundation

enum CocoapodsScanningStrategy {}

extension CocoapodsScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        guard
            let executable = podExecutable,
            let jsonString = Shell.run(
                command: executable,
                with: Command.podDumpArgs.appending(file.name),
                at: file.directory
            ),
            let pod = decode(Pod.self, from: jsonString, strategy: .convertFromSnakeCase),
            let targetDefinitions = pod.targetDefinitions
        else {
            return []
        }

        let repositories: [Repository] = targetDefinitions
            .compactMap(\.children)
            .flatMap { $0 }
            .compactMap(\.dependencies)
            .flatMap { $0 }
            .reduce(into: []) { result, dependencies in
                result += dependencies.map { Repository(name: $0.key, url: "/test/url", version: $0.value.first) }
            }

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
