public struct Repository {

    let name: String
    let url: String
}

extension Repository: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(url.gitSuffixIgnoring)
    }

    public static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.url.gitSuffixIgnoring == rhs.url.gitSuffixIgnoring
    }
}

public typealias Repositories = Set<Repository>

fileprivate extension String {

    var gitSuffixIgnoring: String {
        let gitSuffix = ".git"
        return hasSuffix(gitSuffix) ? replacingOccurrences(of: gitSuffix, with: "") : self
    }
}
