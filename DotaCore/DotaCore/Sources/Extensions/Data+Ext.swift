import Foundation

public extension Data {
  func decode<T: Decodable>(_ type: T.Type, decoder: JSONDecoder) throws -> T {
    return try decoder.decode(type, from: self)
  }
}
