public struct Component: Hashable {

    let name: String?
    let url: String

    init?(name: String?, url: String) {
        self.name = name
        self.url = url
    }
}

public typealias ComponentsSet = Set<Component>
