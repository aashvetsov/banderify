import ArgumentParser
import bearhunterlib

public struct BearhunterScanCommand {

    public typealias Output = Repositories
    
    @Option(name: .shortAndLong, help: "Path to the directory with project")
    private var path: String?

    private static var output: Output?

    public init() {}

    public static func execute(with arguments: [String]?) throws -> Output? {
        var cmd = try BearhunterScanCommand.parseAsRoot(arguments)
        try cmd.run()
        return Self.output
    }
}

extension BearhunterScanCommand: ParsableCommand {

    public mutating func run() throws {
        Self.output = try Bearhunter.scan(path)
    }
}
