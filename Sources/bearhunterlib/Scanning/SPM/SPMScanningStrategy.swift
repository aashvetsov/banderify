import Foundation
import SwiftShell

enum SPMScanningStrategy {}

extension SPMScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        guard
            let jsonString = Shell.run(
                command: Command.swift,
                with: Command.packageDumsArgs,
                at: file.directory
            ),
            let jsonData = jsonString.data(using: .utf8),
            let package = try? JSONDecoder().decode(Package.self, from: jsonData),
            let dependencies = package.dependencies
        else {
            return []
        }

        let repositories = dependencies
            .compactMap(\.scm)
            .flatMap { $0 }
            .map { Repository(name: $0.identity, url: $0.location) }

        return Set(repositories)
    }
}

fileprivate extension SPMScanningStrategy {

    enum Command {
        static let swift = "swift"
        static let packageDumsArgs = ["package", "dump-package"]
    }
}
