import Foundation
import SwiftShell

enum SPMScanningStrategy {}

extension SPMScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories? {
        guard
            let json = file.packageJSONDump,
            let package = decode(Package.self, from: json),
            let repositories = package.repositories
        else {
            return nil
        }

        return repositories
    }
}

fileprivate extension ConfigFile {

    enum Command {
        static let swift = "swift"
        static let packageDumsArgs = ["package", "dump-package"]
    }

    var packageJSONDump: String? {
        Shell.run(
            command: Command.swift,
            with: Command.packageDumsArgs,
            at: directory
        )
    }
}

fileprivate extension Package {

    var repositories: Repositories? {
        scms?
            .compactMap(Repository.init)
            .set()
    }
}

fileprivate extension Repository {

    typealias SCM = Package.Dependency.SCM

    init?(_ scm: SCM) {
        self.init(name: scm.identity, url: scm.location)
    }
}
