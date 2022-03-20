public struct Repository: Hashable {

    let name: String
    let url: String
}

public typealias Repositories = Set<Repository>
