import Foundation

extension Array {

    // TODO: write docu,emtation for this method's purposes
    @inlinable
    func flatMap<SegmentOfResult>(
        _ transform: (Element) throws -> SegmentOfResult?
    ) rethrows -> [SegmentOfResult.Element] where SegmentOfResult: Sequence {
        try compactMap(transform).flatMap { $0 }
    }
}
