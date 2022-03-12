import Foundation

public extension Bundle {

    // swiftlint:disable:next force_unwrapping
    private static var resourcesBunldePath: String { testResources!.bundlePath }

    static var allDMsPath: String {
        "\(resourcesBunldePath)/Contents/Resources/TestDoubles/Stubs/all"
    }

    static var notExistingPath: String {
        "\(resourcesBunldePath)/not_existing"
    }

    static var noConfigFilesPath: String {
        "\(resourcesBunldePath)/Contents/Resources/TestDoubles/Stubs/empty"
    }
}
