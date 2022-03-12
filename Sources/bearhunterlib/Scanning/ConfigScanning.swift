protocol ConfigScanning: Any {
    static func scan(_ file: ConfigFile) -> ComponentsSet
}
