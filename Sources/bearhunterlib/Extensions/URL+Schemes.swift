import Foundation

extension URL {

    var noSchemeURL: URL {
        guard
            absoluteString.contains(Conststants.schemePrefix),
            case let components = absoluteString.components(separatedBy: Conststants.schemePrefix),
            components.count > 1,
            let noSchemeString = components.last,
            let url = URL(string: noSchemeString)
        else {
            return self
        }
        return url
    }

    var fileURL: URL {
        guard
            !absoluteString.contains(Conststants.fileScheme),
            let url = URL(string: Conststants.fileScheme + absoluteString)
        else {
            return self
        }
        return url
    }

    enum Conststants {
        static let fileScheme = "file://"
        static let schemePrefix = "://"
    }
}
