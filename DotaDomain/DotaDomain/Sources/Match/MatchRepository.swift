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
      method: .GET,
      query: [
        URLQueryItem(name: "limit", value: "20"),
        URLQueryItem(name: "project", value: "item_0"),
        URLQueryItem(name: "project", value: "item_1"),
        URLQueryItem(name: "project", value: "item_2"),
        URLQueryItem(name: "project", value: "item_3"),
        URLQueryItem(name: "project", value: "item_4"),
        URLQueryItem(name: "project", value: "item_5"),
        URLQueryItem(name: "project", value: "backpack_0"),
        URLQueryItem(name: "project", value: "duration"),
        URLQueryItem(name: "project", value: "game_mode"),
        URLQueryItem(name: "project", value: "lobby_type"),
        URLQueryItem(name: "project", value: "start_time"),
        URLQueryItem(name: "project", value: "hero_id"),
        URLQueryItem(name: "project", value: "version"),
        URLQueryItem(name: "project", value: "kills"),
        URLQueryItem(name: "project", value: "deaths"),
        URLQueryItem(name: "project", value: "assists"),
        URLQueryItem(name: "project", value: "skill"),
        URLQueryItem(name: "project", value: "leaver_status"),
        URLQueryItem(name: "project", value: "party_size"),
        URLQueryItem(name: "project", value: "item_neutral"),
        URLQueryItem(name: "project", value: "xp_per_min"),
        URLQueryItem(name: "project", value: "gold_per_min"),
        URLQueryItem(name: "project", value: "hero_damage"),
        URLQueryItem(name: "project", value: "tower_damage"),
        URLQueryItem(name: "project", value: "hero_healing"),
        URLQueryItem(name: "project", value: "last_hits"),
      ]
    )
  }

  public init() {}

  public func matches() -> [Match]? {
    try? cache.loadFile(path: resource.path + ".json")
      .decode([Match].self, decoder: JSONDecoder())
  }

  public func fetchMatches() async throws -> [Match] {
    let request = resource.toRequest(environment.apiBaseURL)
    let matches = try await session.fetch([Match].self, request: request, decoder: JSONDecoder())
    try cache.persist(item: matches, encoder: JSONEncoder(), path: resource.path + ".json")

    return matches
  }

  func fetchMatches(heroId: Int) async throws -> [Match] {
    var resource = self.resource
    resource.query.append(URLQueryItem(name: "hero_id", value: "\(heroId)"))
    let request = resource.toRequest(environment.apiBaseURL)
    let matches = try await session.fetch([Match].self, request: request, decoder: JSONDecoder())
    try cache.persist(
      item: matches,
      encoder: JSONEncoder(),
      path: resource.path + "/\(heroId)" + ".json"
    )

    return matches
  }
}
