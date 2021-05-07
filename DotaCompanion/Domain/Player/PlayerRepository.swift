import Combine
import Foundation

extension URLSession {
  static let withCache: URLSession = {
    let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let diskCacheURL = cachesURL.appendingPathComponent("DownloadCache")
    let cache = URLCache(memoryCapacity: 10_000_000, diskCapacity: 1_000_000_000, directory: diskCacheURL)
    let config = URLSessionConfiguration.default
    config.urlCache = cache
    return URLSession(configuration: config)
  }()
}

final class PlayerRepository {
  private let playerId = CurrentUser.currentUserId
  private let environment: ENV = .prod
  private let session = URLSession.withCache
  private let playerCache = FileCache(name: "PlayerRepository")

  func getPlayer() -> AnyPublisher<Player, CoreError> {
    let resource = Resource(
      path: "players/\(playerId)",
      method: .GET
    )
    let request = resource.toRequest(environment.apiBaseURL)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return session.dataTaskPublisher(for: request)
      .map(\.data)
      .prependAndStore(from: playerCache, path: resource.path + ".json")
      .decode(type: Player.self, decoder: decoder)
      .mapError(CoreError.network)
      .eraseToAnyPublisher()
  }

  func winLoses() -> AnyPublisher<WinsStats, CoreError> {
    let resource = Resource(
      path: "players/\(playerId)/wl",
      method: .GET
    )
    let request = resource.toRequest(environment.apiBaseURL)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return session.dataTaskPublisher(for: request)
      .map(\.data)
      .prependAndStore(from: playerCache, path: resource.path + ".json")
      .decode(type: WinsStats.self, decoder: decoder)
      .mapError(CoreError.network)
      .eraseToAnyPublisher()
  }

  func rankImage(for player: Player) -> RankIcon? {
    if let leaderBank = player.leaderboardRank {
      if leaderBank <= 10 { // top 10 and top 100 positions have different icons
        return RankIcon(
          medal: environment.appBaseURL
            .appendingPathComponent("/assets/images/dota2/rank_icons/rank_icon_8c.png")
        )
      } else if leaderBank <= 100 {
        return RankIcon(
          medal: environment.appBaseURL
            .appendingPathComponent("/assets/images/dota2/rank_icons/rank_icon_8b.png")
        )
      } else {
        return RankIcon(
          medal: environment.appBaseURL
            .appendingPathComponent("/assets/images/dota2/rank_icons/rank_icon_8.png")
        )
      }
    } else if player.rankTier > 0 {
      var star = player.rankTier % 10
      if star < 1 {
        star = 1
      } else if star > 7 {
        star = 7
      }
      let icon = Int(floor(Double(player.rankTier) / 10))
      return RankIcon(
        stars: environment.appBaseURL
          .appendingPathComponent("/assets/images/dota2/rank_icons/rank_star_\(star).png"),
        medal: environment.appBaseURL
          .appendingPathComponent("/assets/images/dota2/rank_icons/rank_icon_\(icon).png")
      )
    } else {
      return nil
    }
  }
}
