import Foundation

enum FileFinder {}

extension FileFinder {

    static func existingFiles(
        by descriptor: FileDescriptor,
        at sourceDirectory: String
    ) -> [String]? {
        guard
            let enumerator = FileManager.default.enumerator(atPath: sourceDirectory),
            let allFiles = enumerator.allObjects as? [String]
        else {
            return nil
        }

        let filtered = allFiles
            .compactMap(\.path)
            .filter { FileDescriptor(string: $0) =~ descriptor }

        return filtered.isEmpty ? nil : filtered
    }
}

fileprivate extension String {

    var path: String? { URL(string: self)?.absoluteString }
}
