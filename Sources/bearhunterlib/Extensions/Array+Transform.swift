import Foundation

extension Array {

    @inlinable
    func flatMap<SegmentOfResult>(
        _ transform: (Element) throws -> SegmentOfResult?
    ) rethrows -> [SegmentOfResult.Element] where SegmentOfResult: Sequence {
        try compactMap(transform).flatMap { $0 }
    }

    @inlinable
    func set() -> Set<Element>? where Element: Hashable {
        isEmpty ? nil : Set(self)
    }
}
