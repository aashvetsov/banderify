import Foundation
import SwiftShell

enum SPMScanningStrategy {}

extension SPMScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        let runningDirectory = main.currentdirectory
        defer {
            main.currentdirectory = runningDirectory
        }

        main.currentdirectory = file.directory
        let output = run(bash: BashCommands.dumpPackageSwift)
        let jsonString = output.stdout

        guard
            !jsonString.isEmpty,
            let jsonData = jsonString.data(using: .utf8),
            case let decoder = JSONDecoder(),
            let package: Package = try? decoder.decode(Package.self, from: jsonData),
            let dependencies = package.dependencies
        else {
            return []
        }

        let repositories = dependencies
            .compactMap(\.scm)
            .flatMap { $0 }
            .compactMap { Repository(name: $0.identity, url: $0.location) }

        return Set(repositories)
    }
}

fileprivate extension SPMScanningStrategy {

    enum BashCommands {
        static let dumpPackageSwift = "swift package dump-package"
    }
}
