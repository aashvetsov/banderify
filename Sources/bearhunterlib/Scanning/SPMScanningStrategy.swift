import Foundation
import SwiftShell

enum SPMScanningStrategy {}

extension SPMScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> ComponentsSet {
        let runningDirectory = main.currentdirectory
        defer {
            main.currentdirectory = runningDirectory
        }

        main.currentdirectory = file.directory
        let jsonString = run(bash: BashCommands.dumpPackageSwift).stdout

        guard
            let jsonData = jsonString.data(using: .utf8),
            case let decoder = JSONDecoder(),
            let package: Package = try? decoder.decode(Package.self, from: jsonData),
            let dependencies = package.dependencies
        else {
            return []
        }

        let components = dependencies
            .compactMap(\.scm)
            .flatMap { $0 }
            .compactMap { Component(name: $0.identity, url: $0.location) }

        return Set(components)
    }
}

fileprivate extension SPMScanningStrategy {

    struct Package: Decodable, Hashable {

        public struct Dependency: Decodable, Hashable {

            public let scm: Set<SCM>?
        }

        public struct SCM: Decodable, Hashable {

            public let identity: String
            public let location: String
        }

        public let dependencies: Set<Dependency>?
    }
}

fileprivate extension SPMScanningStrategy {

    enum BashCommands {
        static let dumpPackageSwift = "swift package dump-package"
    }
}
