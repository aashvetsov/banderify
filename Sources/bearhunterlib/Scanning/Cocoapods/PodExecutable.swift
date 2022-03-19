import Foundation

enum PodExecutable: String, CaseIterable {
    case gem = "/usr/local/bin/pod"
    case homebrew = "/opt/homebrew/bin/pod"

    static let installArgs = ["install", "--repo-update"]
    static let podsDumpArgs = ["ipc", "podfile-json"]
    static let podspecDumpArgs = ["ipc", "spec"]
}

extension PodExecutable {

    static var installed: PodExecutable? {
        allCases.first(where: { FileManager.default.fileExists(atPath: $0.rawValue) })
    }

    @discardableResult
    static func install(at directory: String) -> String? {
        guard let executable = installed else { return nil }
        return Shell.run(
            command: executable.rawValue,
            with: PodExecutable.installArgs,
            at: directory
        )
    }

    static func podsJSONDump(for url: URL) -> String? {
        guard
            let executable = installed,
            let fileName = url.fileName,
            let directory = url.directory
        else {
            return nil
        }
        return Shell.run(
            command: executable.rawValue,
            with: PodExecutable.podsDumpArgs + [fileName],
            at: directory
        )
    }

    static func podspecJSONDump(for url: URL) -> String? {
        guard
            let executable = installed,
            let fileName = url.fileName,
            let directory = url.directory
        else {
            return nil
        }
        return Shell.run(
            command: executable.rawValue,
            with: PodExecutable.podspecDumpArgs + [fileName],
            at: directory
        )
    }
}
