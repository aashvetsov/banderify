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

extension Array where Element == CocoapodsScanningStrategy.TargetDefinitionChild {

    var dependencies: [String] {
        self.compactMap(\.dependencies)
            .flatMap { $0 }
            .flatMap(\.keys)
    }
}
