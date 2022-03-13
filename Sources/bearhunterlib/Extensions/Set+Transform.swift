extension Set {

    func setmap<T>(_ transform: (Element) throws -> T) rethrows -> Set<T> {
        try Set<T>(lazy.map(transform))
    }
}
