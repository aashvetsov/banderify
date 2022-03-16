import CarthageKit

extension CocoapodsScanningStrategy {

    struct Pod: Decodable {

        typealias Dependency = [String: [String]]

        struct TargetDefinition: Decodable {

            struct TargetDefinitionChild: Decodable {

                let dependencies: [Dependency]?
            }

            let children: [TargetDefinitionChild]?
        }

        let targetDefinitions: [TargetDefinition]?

        let sources: [String]?
    }
}
