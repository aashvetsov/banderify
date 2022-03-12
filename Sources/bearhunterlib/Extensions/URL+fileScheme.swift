import Foundation

extension URL {

    var prefixedFileScheme: URL {
        // swiftlint:disable:next force_unwrapping
        URL(string: "file://\(absoluteString)")!
    }
}
