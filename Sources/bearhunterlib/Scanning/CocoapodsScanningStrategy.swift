enum CocoapodsScanningStrategy {}

extension CocoapodsScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> Repositories {
        let fileUrl = file.url.prefixedFileScheme
        guard let podsSourceCode = try? String(contentsOf: fileUrl, encoding: .utf8) else { return [] }
        return []
    }
}
