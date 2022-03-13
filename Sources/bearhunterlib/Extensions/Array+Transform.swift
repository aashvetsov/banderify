extension Array {

    func appending(_ newElement: Element) -> Array {
        appending([newElement])
    }

    func appending(_ newElements: [Element]) -> Array {
        var result = Array(self)
        result.append(contentsOf: newElements)
        return result
    }
}
