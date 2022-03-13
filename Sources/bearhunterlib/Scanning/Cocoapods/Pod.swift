import CarthageKit
extension CocoapodsScanningStrategy {

    struct Pod: Decodable {

        let targetDefinitions: [TargetDefinition]?

        let sources: [String]?
    }

    struct TargetDefinition: Decodable {

        let children: [TargetDefinitionChild]?
    }

    struct TargetDefinitionChild: Decodable {

        let dependencies: [Dependency]?
    }

    typealias Dependency = [String: [String]]
}
