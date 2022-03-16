import Foundation
import SwiftShell

enum SPMScanningStrategy {}

extension SPMScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories? {
        guard
            let jsonOutput = Shell.run(
                command: Command.swift,
                with: Command.packageDumsArgs,
                at: file.directory
            ),
            let dependencies = decode(Package.self, from: jsonOutput)?.dependencies,
            let repositories = dependencies
                .flatMap(\.scm)
                .compactMap(Repository.init)
                .set()
        else {
            return nil
        }

        return repositories
    }
}

fileprivate extension SPMScanningStrategy {

    enum Command {
        static let swift = "swift"
        static let packageDumsArgs = ["package", "dump-package"]
    }
}

fileprivate extension Repository {

    typealias SCM = SPMScanningStrategy.Package.Dependency.SCM

    init?(_ scm: SCM) {
        self.init(name: scm.identity, url: scm.location)
    }
}
