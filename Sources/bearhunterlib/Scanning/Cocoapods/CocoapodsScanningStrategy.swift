import Foundation

enum CocoapodsScanningStrategy {}

extension CocoapodsScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        let arguments = Command.podDumpArgs.appending(file.name)
        let jsonString = Shell.run(
            command: Command.pod,
            with: arguments,
            at: file.directory
        )?
            .prettified(using: PodJSON.startMarker)

        guard
            let jsonData = jsonString?.data(using: .utf8),
            let pod: Pod = try? JSONDecoder.snake.decode(Pod.self, from: jsonData),
            let targetDefinitions = pod.targetDefinitions
        else {
            return []
        }

        let sources = pod.sources

        let repositories = targetDefinitions
            .compactMap(\.children)
            .flatMap(\.dependencies)
            .compactMap { Repository(name: $0, url: "/url/test") }

        // TODO: get url for each repo by name

        return Set(repositories)
    }
}

fileprivate extension CocoapodsScanningStrategy {

    enum Command {
        static let pod = "/usr/local/bin/pod"
        static let podDumpArgs = ["ipc", "podfile-json"]
    }

    enum PodJSON {
        static let startMarker = "{\"target_definitions\""
    }
}

fileprivate extension JSONDecoder {

    static var snake: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
