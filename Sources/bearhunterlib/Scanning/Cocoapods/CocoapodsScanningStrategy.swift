import Foundation

enum CocoapodsScanningStrategy {}

extension CocoapodsScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        guard
            let jsonString = Shell.run(
                command: Command.pod,
                with: Command.podDumpArgs.appending(file.name),
                at: file.directory
            ),
            let jsonData = jsonString.data(using: .utf8),
            let pod: Pod = try? JSONDecoder.snake.decode(Pod.self, from: jsonData),
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

    enum Command {
        static let pod = "/usr/local/bin/pod"
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
