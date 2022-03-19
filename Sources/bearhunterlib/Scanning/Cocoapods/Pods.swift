import CarthageKit
import Foundation

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

extension Pods.Dependency {

    var name: String? { compactMap { $0.key }.first }

    var url: String? {
        guard let jsonString = podspecJSON else { return nil }
        let podspec = decode(Podscpec.self, from: jsonString)
        return podspec?.source.values.first
    }

    var version: String? { compactMap { $0.value.first }.first }
}

fileprivate extension Pods.Dependency {

    var podspecJSON: String? {
        if  let podspecJSONURL = podspecJSONURL,
            let json = try? String(contentsOf: podspecJSONURL, encoding: .utf8) {
            return json
        }

        if  let podspecRubyURL = podspecRubyURL,
            let json = PodExecutable.podspecJSONDump(for: podspecRubyURL) {
            return json
        }

        return nil
    }

    var podspecRubyURL: URL? { url(for: Constants.podspec) }

    var podspecJSONURL: URL? { url(for: Constants.podspecJSON)?.fileURL }

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
            let url = URL(string: "\(reposDirectory)/\(file)")
        else {
            return nil
        }

        return url
    }
}

fileprivate extension Pods.Dependency {

    enum Constants {
        // TODO: implement locator for this directory
        static let podsRepoDirectory = "/Users/iuada0h5/.cocoapods/repos"
        static let podspec = ".podspec"
        static let podspecJSON = ".podspec.json"
    }
}
