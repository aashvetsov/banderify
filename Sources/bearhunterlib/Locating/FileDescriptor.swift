import Foundation

struct FileDescriptor: Equatable {

    let name: String?
    let ext: String?

    init?(string: String) {
        guard let nameWithExt = URL(string: string)?.lastPathComponent else { return nil }

        let components = nameWithExt.components(separatedBy: ".")
        name = components.count > 1 ? components.dropLast().joined(separator: ".") : components.first
        ext = components.count > 1 ? components.last : nil
    }
}

infix operator =~
func =~ (
    left: FileDescriptor?,
    right: FileDescriptor?
) -> Bool {
    guard let left = left, let right = right else { return false }

    if let leftExt = left.ext, let rightExt = right.ext,
       !leftExt.isEmpty, !rightExt.isEmpty,
       let leftName = left.name, let rightName = right.name,
          !leftName.isEmpty, !rightName.isEmpty {
        return left == right
    }

    if let leftExt = left.ext, let rightExt = right.ext,
       !leftExt.isEmpty, !rightExt.isEmpty {
        return leftExt == rightExt
    }

    return left == right
}
