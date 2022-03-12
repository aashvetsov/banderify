enum GitSubtreeScanningStrategy {}

extension GitSubtreeScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> ComponentsSet {
        []
    }
}
