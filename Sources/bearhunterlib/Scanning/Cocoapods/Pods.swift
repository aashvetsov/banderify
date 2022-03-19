import CarthageKit
import Foundation

extension CocoapodsScanningStrategy {

    struct Pods: Decodable {

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

extension CocoapodsScanningStrategy.Pods.Dependency {

    var podspec: String? {
        guard
            let podspecURL = podspecURL,
            let contents = try? String(contentsOf: podspecURL, encoding: .utf8)
        else {
            return nil
        }

        return contents
    }
}

fileprivate extension CocoapodsScanningStrategy.Pods.Dependency {

    var reposDirectory: String? {
        // TODO: implement locator for this directory
        Constants.podsRepoDirectory
    }

    var podspecURL: URL? {
        guard
            let reposDirectory = reposDirectory,
            let file = self
                .map(\.key)
                .reduce(into: [String](), { result, dependencyName in
                    if  let descriptor = FileDescriptor(string: dependencyName + Constants.podspec),
                        let files = FileFinder.existingFiles(by: descriptor, at: reposDirectory) {
                        result += files
                    }
                })
                .max(by: <),
            let url = URL(string: "\(reposDirectory)/\(file)")?.fileURL
        else {
            return nil
        }

        return url
    }
}

fileprivate extension CocoapodsScanningStrategy.Pods.Dependency {

    enum Constants {
        static let podsRepoDirectory = "/Users/iuada0h5/.cocoapods/repos"
        static let podspec = ".podspec"
    }

    enum Command {
        static let home = "set -x; echo $HOME { set +x; } 2>/dev/null"
    }
}

