struct ConfigLocator {

    let directory: String
    let type: DMType

    var configFiles: ConfigFiles {
        guard let descriptor = FileDescriptor(string: type.rawValue) else { return [] }
        return Set(
            FileFinder.existingFiles(by: descriptor, at: directory)
                .compactMap {
                    ConfigFile(name: $0, directory: directory, type: type)
                }
        )
    }
}
