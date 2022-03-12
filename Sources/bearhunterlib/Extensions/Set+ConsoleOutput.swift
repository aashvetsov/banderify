extension Set {

    var list: String { setmap { "+ \($0)" }.joined(separator: "\n") }
}
