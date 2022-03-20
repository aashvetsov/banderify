import CarthageKit
import Foundation

struct Pods: Decodable {

    typealias Dependency = [String: [String]]
    typealias Dependencies = [Dependency]

    struct TargetDefinition: Decodable {

        struct TargetDefinitionChild: Decodable {

            let dependencies: Dependencies?
        }

        let children: [TargetDefinitionChild]?
    }

    let targetDefinitions: [TargetDefinition]?

    let sources: [String]?
}

extension Pods {

    var dependencies: Dependencies? {
        targetDefinitions?
            .flatMap(\.children)
            .flatMap(\.dependencies)
    }
}

extension Pods.Dependency {

    var name: String? { compactMap { $0.key }.first }

    var url: String? {
        guard
            let json = podspecLocator.json,
            let podspec = decode(Podspec.self, from: json)
        else {
            return nil
        }

        return podspec.url
    }

    var version: String? { compactMap { $0.value.first }.first }
}

fileprivate extension Pods.Dependency {

    var podspecLocator: PodspecLocator { PodspecLocator(dependency: self) }
}
