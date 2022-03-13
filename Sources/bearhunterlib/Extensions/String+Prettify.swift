extension String {

    func prettified(using marker: String) -> String {
        let prettified = replacingOccurrences(of: "\n", with: "").filter { !$0.isWhitespace }
        guard let index = prettified.range(of: marker)?.lowerBound else { return prettified }
        return String(prettified.suffix(from: index))
    }
}
