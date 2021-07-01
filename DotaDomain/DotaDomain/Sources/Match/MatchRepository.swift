import Foundation
import DotaCore

public final class MatchRepository {
  private let playerId = CurrentUser.currentUserId
  private let environment: ENV = .prod
  private let session = URLSession.shared
  private let cache = FileCache(name: "MatchRepository")

  private var resource: Resource {
    Resource(
      path: "players/\(playerId)/matches",
      method: .GET
    )
  }

  public init() {}

  public func matches() -> [Match] {
    (try? cache.loadFile(path: resource.path + ".json")
      .decode([Match].self, decoder: JSONDecoder())) ?? []
  }

  public func fetchMatches() async throws -> [Match] {
    let request = resource.toRequest(environment.apiBaseURL)
    let matches = try await session.fetch([Match].self, request: request, decoder: JSONDecoder())
    try cache.persist(item: matches, encoder: JSONEncoder(), path: resource.path + ".json")

    return matches
  }
}
