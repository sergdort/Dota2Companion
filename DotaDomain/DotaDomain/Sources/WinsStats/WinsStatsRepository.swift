import Foundation
import DotaCore

public final class WinsStatsRepository {
  private let playerId = CurrentUser.currentUserId
  private let environment: ENV = .prod
  private let session = URLSession.shared
  private let cache = FileCache(name: "WinsStatsRepository")

  private var resource: Resource {
    Resource(
      path: "players/\(playerId)/wl",
      method: .GET
    )
  }

  public init() {}

  public func winLose() -> WinsStats? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return try? cache.loadFile(path: resource.path + ".json")
      .decode(WinsStats.self, decoder: decoder)
  }

  public func fetchWinLoses() async throws -> WinsStats {
    let request = resource.toRequest(environment.apiBaseURL)
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    decoder.keyDecodingStrategy = .convertFromSnakeCase
    encoder.keyEncodingStrategy = .convertToSnakeCase

    let stats = try await session.fetch(WinsStats.self, request: request, decoder: decoder)
    try cache.persist(item: stats, encoder: encoder, path: resource.path + ".json")

    return stats
  }
}
