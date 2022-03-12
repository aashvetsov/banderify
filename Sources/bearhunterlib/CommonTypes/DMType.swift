enum DMType: String, RawRepresentable, CaseIterable {
    case spm = "Package.swift"
    case xcodeproj = ".xcodeproj"
    case carthage = "Cartfile"
    case gitSubmodules = ".gitmodules"
    case gitSubtree = ".gitsubtree"
    case cocoapods = "Podfile"
}
