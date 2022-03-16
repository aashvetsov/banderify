extension Array {

    var multilined: String { map { "+ \($0)" }.joined(separator: "\n") }
}
