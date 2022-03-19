import Foundation

extension URL {

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
    }
}
