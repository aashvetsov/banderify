import Foundation

public extension Bundle {

    static var testResources: Bundle? {
        // TODO: refactor when build phases will be available for SPM (drop xcodeproj)
        spmTestResources ?? xcodeProjTestResources
    }

    private static var xcodeProjTestResources: Bundle? {
        Bundle.allBundles.first(where: { $0.bundlePath.hasSuffix(Constants.xctest) })
    }

    private static var spmTestResources: Bundle? {
        guard
            let testBundle = Bundle.allBundles.first(where: { $0.bundlePath.hasSuffix(Constants.xctest) }),
            case let existingBundlesPaths = testBundle.paths(forResourcesOfType: "bundle", inDirectory: ""),
            let resourceBundlePath = existingBundlesPaths.first(where: { $0.hasSuffix("Tests.bundle") }),
            let resourcesBundle = Bundle(path: resourceBundlePath)
        else {
            return nil
        }
        return resourcesBundle
    }
}

fileprivate extension Bundle {

    enum Constants {
        static let xctest = ".xctest"
    }
}
