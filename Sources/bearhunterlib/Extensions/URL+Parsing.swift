import Foundation

extension URL {

    var fileName: String? {
        lastPathComponent == "/" ? nil : lastPathComponent
    }

    var directory: String? {
        lastPathComponent == "/" ? self.absoluteString : deletingLastPathComponent().absoluteString
    }
}
