import Foundation

extension URL {

    var noSchemeURL: URL {
        let marker = Conststants.schemeSuffix
        let components = absoluteString.components(separatedBy: marker)
        guard
            components.count > 1,
            let noSchemeString = components.last,
            !noSchemeString.isEmpty,
            let url = URL(string: noSchemeString)
        else {
            return self
        }
        return url
    }

    var fileURL: URL {
        let scheme = Conststants.fileScheme
        guard
            !absoluteString.contains(scheme),
            let url = URL(string: scheme + absoluteString)
        else {
            return self
        }
        return url
    }

    enum Conststants {
        static let schemeSuffix = "://"
        static let fileScheme = "file\(schemeSuffix)"
    }
}
