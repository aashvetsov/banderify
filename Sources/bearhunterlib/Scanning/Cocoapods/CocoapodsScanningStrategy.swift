import Foundation

enum CocoapodsScanningStrategy {}

extension CocoapodsScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories? {
        guard
            let json = file.podsJSONDump,
            let pods = decode(Pods.self, from: json, strategy: .convertFromSnakeCase),
            let repositories = pods.targetDefinitions?
                .flatMap(\.children)
                .flatMap(\.dependencies)
                .flatMap(\.repositories)
                .set()
        else {
            return nil
        }

        // TODO: get urls for repositories

        return repositories
    }
}

fileprivate extension ConfigFile {

    enum PodExecutable: String, CaseIterable {
        case gem = "/usr/local/bin/pod"
        case homebrew = "/opt/homebrew/bin/pod"

        static let ipcDumpArgs = ["ipc", "podfile-json"]

        static var installed: PodExecutable? {
            allCases.first(where: { FileManager.default.fileExists(atPath: $0.rawValue) })
        }
    }

    var podsJSONDump: String? {
        guard let executable = PodExecutable.installed else { return nil }
        return Shell.run(
            command: executable.rawValue,
            with: PodExecutable.ipcDumpArgs + [name],
            at: directory
        )
    }
}

fileprivate extension CocoapodsScanningStrategy.Pods.Dependency {

    var repositories: [Repository] {
        map { Repository(name: $0.key, version: $0.value.first) }
    }
}
