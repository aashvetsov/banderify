import ArgumentParser
import bearhunterlib

public struct BearhunterScanCommand {

    @Option(name: .shortAndLong, help: "Path to the directory with project")
    private var path: String?

    private(set) static var output: Repositories?

    public init() {}

    public static func execute(with arguments: [String]?) throws {
        var cmd = try BearhunterScanCommand.parseAsRoot(arguments)
        try cmd.run()
    }
}

extension BearhunterScanCommand: ParsableCommand {

    public mutating func run() throws {
        Self.output = try Bearhunter.scan(path)
    }
}
