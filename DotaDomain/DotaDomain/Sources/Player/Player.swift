import Combine
import Foundation

// https://api.opendota.com/api/players/118113925
public struct Player: Equatable, Codable {
  public var rankTier: Int
  public var leaderboardRank: Int?
  public var profile: Profile

  public init(rankTier: Int, leaderboardRank: Int? = nil, profile: Player.Profile) {
    self.rankTier = rankTier
    self.leaderboardRank = leaderboardRank
    self.profile = profile
  }

  public struct Profile: Equatable, Codable {
    public var accountId: Int
    public var name: String?
    public var personaname: String
    public var avatar: URL
    public var avatarmedium: URL
    public var avatarfull: URL

    public init(
      accountId: Int,
      name: String? = nil,
      personaname: String,
      avatar: URL,
      avatarmedium: URL,
      avatarfull: URL
    ) {
      self.accountId = accountId
      self.name = name
      self.personaname = personaname
      self.avatar = avatar
      self.avatarmedium = avatarmedium
      self.avatarfull = avatarfull
    }
  }
}

public struct RankIcon: Equatable {
  public var stars: URL?
  public var medal: URL

  public init(stars: URL? = nil, medal: URL) {
    self.stars = stars
    self.medal = medal
  }
}
