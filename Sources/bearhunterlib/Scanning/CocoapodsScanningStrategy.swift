import Foundation
import SwiftExec

enum CocoapodsScanningStrategy {}

extension CocoapodsScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        guard
            let jsonString = try? exec(
                program: Shell.pod,
                arguments: Shell.podDumpArgs.appending(file.url.absoluteString)
            ).stdout,
            let jsonData = jsonString.data(using: .utf8),
            let pod: Pod = try? JSONDecoder.snake.decode(Pod.self, from: jsonData),
            let targetDefinitions = pod.targetDefinitions
        else {
            return []
        }

        let sources = pod.sources

        let repositories = targetDefinitions
            .compactMap(\.children)
            .flatMap { $0 }
            .compactMap(\.dependencies)
            .flatMap { $0 }
            .flatMap { $0.keys }
            .compactMap {
                Repository(name: $0, url: "https://github.com/tesrowner/testrepo")
            }

        // TODO: get url for each repo by name

        return Set(repositories)
    }
}

fileprivate extension CocoapodsScanningStrategy {

    enum Shell {
        static let pod = "/usr/local/bin/pod"
        static let podDumpArgs = ["ipc", "podfile-json"]
    }
}

fileprivate extension Array {

    func appending(_ newElement: Element) -> Array {
        var result = Array(self)
        result.append(newElement)
        return result
    }
}

fileprivate extension JSONDecoder {

    static var snake: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

fileprivate extension CocoapodsScanningStrategy {

    struct Pod: Decodable {

        let targetDefinitions: Set<TargetDefinition>?

        let sources: Set<String>?
    }

    struct TargetDefinition: Decodable, Hashable {

        let children: Set<TargetDefinitionChild>?
    }

    struct TargetDefinitionChild: Decodable, Hashable {

        let dependencies: Set<Dependency>?
    }

    typealias Dependency = [String: [String]]
}
