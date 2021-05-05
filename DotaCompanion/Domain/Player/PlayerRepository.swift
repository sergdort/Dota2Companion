import Combine
import Foundation

final class PlayerRepository {
  private let playerId = CurrentUser.currentUserId
  private let baseURL = URL(string: "https://api.opendota.com/api")!
  private let appBaseURL = URL(string: "https://www.opendota.com")!
  private let session = URLSession.shared

  func getPlayer() -> AnyPublisher<Player, CoreError> {
    let resource = Resource(
      path: "players/\(playerId)",
      method: .GET
    )
    let request = resource.toRequest(baseURL)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return session.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: Player.self, decoder: decoder)
      .mapError(CoreError.network)
      .eraseToAnyPublisher()
  }

  func winLoses() -> AnyPublisher<WinsStats, CoreError> {
    let resource = Resource(
      path: "players/\(playerId)/wl",
      method: .GET
    )
    let request = resource.toRequest(baseURL)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return session.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: WinsStats.self, decoder: decoder)
      .mapError(CoreError.network)
      .eraseToAnyPublisher()
  }

  func rankImage(for player: Player) -> RankIcon? {
    if let leaderBank = player.leaderboardRank {
      if leaderBank <= 10 { // top 10 and top 100 positions have different icons
        return RankIcon(
          medal: appBaseURL
            .appendingPathComponent("/assets/images/dota2/rank_icons/rank_icon_8c.png")
        )
      } else if leaderBank <= 100 {
        return RankIcon(
          medal: appBaseURL
            .appendingPathComponent("/assets/images/dota2/rank_icons/rank_icon_8b.png")
        )
      } else {
        return RankIcon(
          medal: appBaseURL
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
        stars: appBaseURL
          .appendingPathComponent("/assets/images/dota2/rank_icons/rank_star_\(star).png"),
        medal: appBaseURL
          .appendingPathComponent("/assets/images/dota2/rank_icons/rank_icon_\(icon).png")
      )
    } else {
      return nil
    }
  }
}
