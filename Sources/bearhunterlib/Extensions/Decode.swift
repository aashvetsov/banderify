import Foundation

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
