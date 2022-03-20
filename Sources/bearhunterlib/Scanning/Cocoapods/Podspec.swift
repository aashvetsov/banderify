import Foundation

struct Podspec: Decodable {

    typealias Source = [String: String]

    let source: Source

    var url: String? { source.values.first }
}
