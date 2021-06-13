import Combine
import Foundation

// https://api.opendota.com/api/players/118113925
public struct Player: Codable {
  public var rankTier: Int
  public var leaderboardRank: Int?
  public var profile: Profile

  public struct Profile: Codable {
    public var accountId: Int
    public var name: String?
    public var personaname: String
    public var avatar: URL
    public var avatarmedium: URL
    public var avatarfull: URL
  }
}

public struct RankIcon {
  public var stars: URL? = nil
  public var medal: URL
}
