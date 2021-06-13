import Foundation

public extension URLSession {
  func fetch<T: Decodable>(
    _ type: T.Type = T.self,
    request: URLRequest,
    decoder: JSONDecoder
  ) async throws -> T {
    let (data, _) = try await self.data(for: request, delegate: nil)
    return try data.decode(type, decoder: decoder)
  }
}
