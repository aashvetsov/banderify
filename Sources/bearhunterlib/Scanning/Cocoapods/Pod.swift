import CarthageKit
extension CocoapodsScanningStrategy {

    struct Pod: Decodable {

        struct TargetDefinition: Decodable {

            struct TargetDefinitionChild: Decodable {

                let dependencies: [Dependency]?
            }

            let children: [TargetDefinitionChild]?
        }

        let targetDefinitions: [TargetDefinition]?

        let sources: [String]?
    }

    typealias Dependency = [String: [String]]
}
