import Foundation

struct FileDescriptor: Equatable {

    let name: String?
    let ext: String?

    init?(string: String) {
        guard let fileNameWithExt = URL(string: string)?.lastPathComponent else { return nil }

        let components = fileNameWithExt.components(separatedBy: ".")
        name = components.first
        ext = components.first != components.last ? components.last : nil
    }
}

infix operator =~
func =~ (
    left: FileDescriptor?,
    right: FileDescriptor?
) -> Bool {
    guard let left = left, let right = right else { return false }

    if let leftExt = left.ext, let rightExt = right.ext,
       !leftExt.isEmpty, !rightExt.isEmpty {
        return leftExt == rightExt
    }

    return left == right
}
