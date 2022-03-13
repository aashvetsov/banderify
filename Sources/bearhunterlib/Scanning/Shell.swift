import SwiftShell

enum Shell {}

extension Shell {

    static func run(
        command: String,
        with arguments: [String]?,
        at directory: String?
    ) -> String? {
        let runningDirectory = main.currentdirectory
        defer {
            main.currentdirectory = runningDirectory
        }

        if let directory = directory {
            main.currentdirectory = directory
        }

        let output = SwiftShell.run(command, arguments ?? [], combineOutput: true)
        let result = output.stdout
        let error = output.stderror

        guard error.isEmpty, !result.isEmpty else { return nil }

        return result
    }
}
