enum GitSubmodulesScanningStrategy {}

extension GitSubmodulesScanningStrategy: ConfigScanning {

    static func scan(_ file: ConfigFile) -> ComponentsSet {
        []
    }
}
