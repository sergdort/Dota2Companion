import Combine
import Foundation
import DotaCore

final class RecentMatchesRepository {
  private let playerId = CurrentUser.currentUserId
  private let environment: ENV = .prod
  private let session = URLSession.shared
  private let cache = FileCache(name: "RecentMatchesRepository")

  private var resource: Resource {
    Resource(
      path: "players/\(playerId)/recentMatches",
      method: .GET
    )
  }

  init() {}

  func recentMatches() -> [RecentMatch]? {
    try? cache.loadFile(path: resource.path + ".json")
      .decode([RecentMatch].self, decoder: JSONDecoder())
  }

  func fetchRecentMatches() async throws -> [RecentMatch] {
    let request = resource.toRequest(environment.apiBaseURL)
    let matches = try await session.fetch([RecentMatch].self, request: request, decoder: JSONDecoder())
    try cache.persist(item: matches, encoder: JSONEncoder(), path: resource.path + ".json")

    return matches
  }
}
