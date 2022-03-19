import SwiftShell

enum Shell {}

extension Shell {

    static func run(
        command: String,
        with arguments: [String]? = nil,
        at directory: String? = nil
    ) -> String? {
        let runningDirectory = main.currentdirectory
        defer {
            main.currentdirectory = runningDirectory
        }

        if let directory = directory {
            main.currentdirectory = directory
        }

        let output = SwiftShell.run(command, arguments ?? [], combineOutput: false)
        let result = output.stdout

        return result.isEmpty ? nil : result
    }
}
