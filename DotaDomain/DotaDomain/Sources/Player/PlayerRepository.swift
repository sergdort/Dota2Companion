import Combine
import Foundation
import DotaCore

final class PlayerRepository {
  private let playerId = CurrentUser.currentUserId
  private let environment: ENV = .prod
  private let session = URLSession.shared
  private let playerCache = FileCache(name: "PlayerRepository")

  private var playerResource: Resource {
    Resource(
      path: "players/\(playerId)",
      method: .GET
    )
  }

  func player() -> Player? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return try? playerCache.loadFile(path: playerResource.path + ".json")
      .decode(Player.self, decoder: decoder)
  }

  func fetchPlayer() async throws -> Player {
    let request = playerResource.toRequest(environment.apiBaseURL)
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    decoder.keyDecodingStrategy = .convertFromSnakeCase
    encoder.keyEncodingStrategy = .convertToSnakeCase

    let player = try await session.fetch(Player.self, request: request, decoder: decoder)
    try playerCache.persist(item: player, encoder: encoder, path: playerResource.path + ".json")

    return player
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
