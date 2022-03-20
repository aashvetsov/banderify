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
        guard let name = scm.identity, let url = scm.location else { return nil }
        self.init(name: name, url: url)
    }
}
