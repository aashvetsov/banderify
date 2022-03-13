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
            let pod: Pod = try? JSONDecoder.snake.decode(Pod.self, from: jsonData)
        else {
            return []
        }

        let sources = pod.sources ?? []
        guard let repositories = pod.targetDefinitions?
            .compactMap(\.children)
            .flatMap({ $0 })
            .compactMap(\.dependencies)
            .flatMap({ $0 })
            .flatMap(\.keys)
            .compactMap({ Repository(name: $0, url: "https://github.com/tesrowner/testrepo") })
        else {
            return []
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

fileprivate extension CocoapodsScanningStrategy {

    struct Pod: Decodable, Hashable {

        struct TargetDefinition: Decodable, Hashable {

            let children: Set<TargetDefinitionChild>?
        }

        struct TargetDefinitionChild: Decodable, Hashable {

            let dependencies: Set<Dependency>?
        }

        typealias Dependency = [String: [String]]

        let targetDefinitions: Set<TargetDefinition>?

        let sources: Set<String>?
    }
}

fileprivate extension JSONDecoder {

    static var snake: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
