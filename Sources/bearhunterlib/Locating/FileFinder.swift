import Foundation

enum FileFinder {}

extension FileFinder {

    static func existingFiles(
        by descriptor: FileDescriptor,
        at sourceDirectory: String
    ) -> [String] {
        guard
            let enumerator = FileManager.default.enumerator(atPath: sourceDirectory),
            let allFiles = enumerator.allObjects as? [String]
        else {
            return []
        }

        return allFiles
            .compactMap(\.fileName)
            .filter { FileDescriptor(string: $0) =~ descriptor }
    }
}

extension String {

    var fileName: String? {
        URL(string: self)?.lastPathComponent
    }
}
