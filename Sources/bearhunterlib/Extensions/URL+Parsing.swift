import Foundation

extension URL {

    var fileName: String? { lastPathComponent } // TODO: check for '/File' value

    var directory: String? { deletingLastPathComponent().absoluteString } // TODO: check for '/File' value
}
