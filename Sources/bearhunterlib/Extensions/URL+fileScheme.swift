import Foundation

// swiftlint:disable force_unwrapping
extension URL {

    var prefixedFileScheme: URL {
        URL(string: "file://\(absoluteString)")!
    }
}
