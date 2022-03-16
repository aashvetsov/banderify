struct ConfigScanner {

    let file: ConfigFile
    var repositories: Repositories? { strategy.scan(file) }
}

fileprivate extension ConfigScanner {

    var strategy: ConfigScanning.Type {
        switch file.type {
        case .spm: return SPMScanningStrategy.self
        case .xcodeproj: return XcodeProjScanningStrategy.self
        case .carthage: return CarthageScanningStrategy.self
        case .gitSubmodules: return GitSubmodulesScanningStrategy.self
        case .gitSubtree: return GitSubtreeScanningStrategy.self
        case .cocoapods: return CocoapodsScanningStrategy.self
        }
    }
}
