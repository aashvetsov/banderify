import Foundation

enum FileFinder {}

extension FileFinder {

    static func existingFiles(
        by descriptor: FileDescriptor,
        at sourceDirectory: String
    ) -> Set<String> {
        guard
            let enumerator = FileManager.default.enumerator(atPath: sourceDirectory),
            let allFiles = enumerator.allObjects as? [String]
        else {
            return []
        }

        return Set(
            allFiles.filter {
                guard let fileName = URL(string: $0)?.lastPathComponent else { return false }
                return FileDescriptor(string: fileName) =~ descriptor
            }
        )
    }
}
