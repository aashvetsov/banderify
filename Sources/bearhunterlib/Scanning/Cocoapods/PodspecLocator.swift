import Foundation

struct PodspecLocator {

    let dependency: Pods.Dependency
}

extension PodspecLocator {

    var json: String? {
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
}

fileprivate extension PodspecLocator {

    var podspecRubyURL: URL? { url(for: Constants.podspec) }

    var podspecJSONURL: URL? { url(for: Constants.podspecJSON)?.fileURL }

    var reposDirectory: String? {
        guard let url = URL(string: Constants.podsRepoDirectory)?.noSchemeURL else { return nil }
        return url.absoluteString
    }

    func url(for fileExtension: String) -> URL? {
        guard
            let reposDirectory = reposDirectory,
            let file = self.dependency
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

fileprivate extension PodspecLocator {

    enum Constants {
        static let podsRepoDirectory = "\(FileManager.default.homeDirectoryForCurrentUser).cocoapods/repos"
        static let podspec = ".podspec"
        static let podspecJSON = ".podspec.json"
    }
}
