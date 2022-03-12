var args = CommandLine.arguments
guard !args.isEmpty else { preconditionFailure("Call without args is not supported") }
args.removeFirst()
try BearhunterScanCommand.execute(with: args)
