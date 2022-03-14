import Foundation

func decode<T: Decodable>(
    _: T.Type,
    from string: String,
    strategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
) -> T? {
    guard let data = string.data(using: .utf8) else { return nil }
    return decode(T.self, from: data, strategy: strategy)
}

func decode<T: Decodable>(
    _: T.Type,
    from data: Data,
    strategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
) -> T? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = strategy
    do {
        return try decoder.decode(T.self, from: data)
    } catch {
        return nil
    }
}
