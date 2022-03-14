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
            let jsonData = jsonString.data(using: .utf8),
            let pod = try? JSONDecoder.snake.decode(Pod.self, from: jsonData),
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

    static var podExecutable: String? {
        PodExecutable.allCases
            .map(\.rawValue)
            .first(where: { FileManager.default.fileExists(atPath: $0) })
    }
}

fileprivate extension CocoapodsScanningStrategy {

    enum PodExecutable: String, CaseIterable {
        case bundler = "/usr/local/bin/pod"
        case homebrew = "/opt/homebrew/bin/pod"
    }

    enum Command {
        static let podDumpArgs = ["ipc", "podfile-json"]
    }
}

fileprivate extension JSONDecoder {

    static var snake: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
