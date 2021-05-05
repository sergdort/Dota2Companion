import Combine
import Foundation

// https://api.opendota.com/api/players/118113925
public struct Player: Decodable {
  public var rankTier: Int
  public var leaderboardRank: Int?
  public var profile: Profile

  public struct Profile: Decodable {
    public var accountId: Int
    public var name: String?
    public var personaname: String
    public var avatar: URL
    public var avatarmedium: URL
    public var avatarfull: URL
  }
}

public struct WinsStats: Decodable {
  public var win: Int
  public var lose: Int

  public init(win: Int, lose: Int) {
    self.win = win
    self.lose = lose
  }
}

public struct RankIcon {
  public var stars: URL? = nil
  public var medal: URL
}
