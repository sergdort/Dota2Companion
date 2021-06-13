import Combine
import Foundation
import DotaCore

public final class MatchesRepository {
  private let playerId = CurrentUser.currentUserId
  private let environment: ENV = .prod
  private let session = URLSession.shared
  private let cache = FileCache(name: "MatchesRepository")

  private var resource: Resource {
    Resource(
      path: "players/\(playerId)/recentMatches",
      method: .GET
    )
  }

  func recentMatches() -> [Match] {
    (try? cache.loadFile(path: resource.path + ".json")
      .decode([Match].self, decoder: JSONDecoder())) ?? []
  }

  func fetchRecentMatches() async throws -> [Match] {
    let request = resource.toRequest(environment.apiBaseURL)
    let matches = try await session.fetch([Match].self, request: request, decoder: JSONDecoder())
    try cache.persist(item: matches, encoder: JSONEncoder(), path: resource.path + ".json")

    return matches
  }
}
