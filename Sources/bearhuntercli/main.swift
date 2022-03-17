var args = CommandLine.arguments
args.removeFirst()
guard !args.isEmpty else { preconditionFailure("Call command without arguments is not supported") }
_ = try BearhunterScanCommand.execute(with: args)
