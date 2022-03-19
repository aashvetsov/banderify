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

    var podspecJSON: String? {
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

    var podspecURL: URL? {
        podspecJSONURL ?? podspecRubyURL
    }

    var podspecRubyURL: URL? { url(for: Constants.podspec) }

    var podspecJSONURL: URL? { url(for: Constants.podspecJSON) }

    var reposDirectory: String? {
        // TODO: implement locator for this directory
        Constants.podsRepoDirectory
    }

    func url(for fileExtension: String) -> URL? {
        guard
            let reposDirectory = reposDirectory,
            let file = self
                .map(\.key)
                .reduce(into: [String](), { result, dependencyName in
                    if  let descriptor = FileDescriptor(string: dependencyName + fileExtension),
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
        static let podsRepoDirectory = "/Users/iuada0h5/.cocoapods/repos" // TODO: implement locator for this directory
        static let podspec = ".podspec"
        static let podspecJSON = ".podspec.json"
    }
}
