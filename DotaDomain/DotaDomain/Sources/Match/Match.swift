import Foundation

public struct Match: Codable {
  public var matchID, playerSlot: Int
  public var radiantWin: Bool
  public var duration, gameMode, lobbyType, heroID: Int
  public var startTime: Int
  public var version: Int?
  public var kills, deaths, assists: Int
  public var skill: Int?
  public var xpPerMin, goldPerMin, heroDamage, towerDamage: Int
  public var heroHealing, lastHits: Int
  public var lane, laneRole: Int?
  public var isRoaming: Bool?
  public var cluster, leaverStatus: Int
  public var partySize: Int?

  public var isRadiant: Bool {
    playerSlot < 128
  }

  public var isWin: Bool {
    isRadiant == radiantWin
  }

  public init(
    matchID: Int,
    playerSlot: Int,
    radiantWin: Bool,
    duration: Int,
    gameMode: Int,
    lobbyType: Int,
    heroID: Int,
    startTime: Int,
    version: Int? = nil,
    kills: Int,
    deaths: Int,
    assists: Int,
    skill: Int? = nil,
    xpPerMin: Int,
    goldPerMin: Int,
    heroDamage: Int,
    towerDamage: Int,
    heroHealing: Int,
    lastHits: Int,
    lane: Int? = nil,
    laneRole: Int? = nil,
    isRoaming: Bool? = nil,
    cluster: Int,
    leaverStatus: Int,
    partySize: Int? = nil
  ) {
    self.matchID = matchID
    self.playerSlot = playerSlot
    self.radiantWin = radiantWin
    self.duration = duration
    self.gameMode = gameMode
    self.lobbyType = lobbyType
    self.heroID = heroID
    self.startTime = startTime
    self.version = version
    self.kills = kills
    self.deaths = deaths
    self.assists = assists
    self.skill = skill
    self.xpPerMin = xpPerMin
    self.goldPerMin = goldPerMin
    self.heroDamage = heroDamage
    self.towerDamage = towerDamage
    self.heroHealing = heroHealing
    self.lastHits = lastHits
    self.lane = lane
    self.laneRole = laneRole
    self.isRoaming = isRoaming
    self.cluster = cluster
    self.leaverStatus = leaverStatus
    self.partySize = partySize
  }

  enum CodingKeys: String, CodingKey {
    case matchID = "match_id"
    case playerSlot = "player_slot"
    case radiantWin = "radiant_win"
    case duration
    case gameMode = "game_mode"
    case lobbyType = "lobby_type"
    case heroID = "hero_id"
    case startTime = "start_time"
    case version, kills, deaths, assists, skill
    case xpPerMin = "xp_per_min"
    case goldPerMin = "gold_per_min"
    case heroDamage = "hero_damage"
    case towerDamage = "tower_damage"
    case heroHealing = "hero_healing"
    case lastHits = "last_hits"
    case lane
    case laneRole = "lane_role"
    case isRoaming = "is_roaming"
    case cluster
    case leaverStatus = "leaver_status"
    case partySize = "party_size"
  }

  public static func sortByKillsDesc(lhs: Match, rhs: Match) -> Bool {
    return lhs.kills > rhs.kills
  }
}
