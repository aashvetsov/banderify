struct ConfigLocator {

    let directory: String
    let type: DMType

    var configFiles: ConfigFiles? {
        guard
            let descriptor = FileDescriptor(string: type.rawValue),
            let files = FileFinder.existingFiles(by: descriptor, at: directory)?
                .compactMap({ ConfigFile(name: $0, directory: directory, type: type) })
                .set()
        else {
            return nil
        }

        return files
    }
}
