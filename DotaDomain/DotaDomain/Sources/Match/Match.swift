import Foundation
import CodableWrappers

public struct Match: Codable, Equatable {
  public var matchID, playerSlot: Int
  public var radiantWin: Bool
  public var lastHits, heroHealing, xpPerMin, goldPerMin, heroDamage, towerDamage: Int?
  public var duration, gameMode, lobbyType, startTime: Int
  public var heroID: Int
  public var version: Int?
  public var kills, deaths, assists: Int
  public var skill: Int?
  public var leaverStatus: Int
  public var partySize: Int?
  public var item0, item1, item2, item3, item4, item5: Int?
  public var neutralItem: Int?
  public var backpack0: Int?

  public var isWin: Bool {
    isRadiant == radiantWin
  }

  public var isRadiant: Bool {
    playerSlot < 128
  }

  public var itemsIds: [Int] {
    return [item0, item1, item2, item3, item4, item5, neutralItem].compactMap { $0 }
  }

  public init(
    matchID: Int,
    playerSlot: Int,
    radiantWin: Bool,
    duration: Int,
    gameMode: Int,
    lobbyType: Int,
    startTime: Int,
    heroID: Int,
    version: Int? = nil,
    kills: Int,
    deaths: Int,
    assists: Int,
    skill: Int? = nil,
    leaverStatus: Int,
    partySize: Int? = nil,
    item0: Int? = nil,
    item1: Int? = nil,
    item2: Int? = nil,
    item3: Int? = nil,
    item4: Int? = nil,
    item5: Int? = nil,
    backpack0: Int? = nil,
    lastHits: Int = 200,
    heroHealing: Int = 0,
    xpPerMin: Int = 0,
    goldPerMin: Int = 0,
    heroDamage: Int = 0,
    towerDamage: Int = 0
  ) {
    self.matchID = matchID
    self.playerSlot = playerSlot
    self.radiantWin = radiantWin
    self.duration = duration
    self.gameMode = gameMode
    self.lobbyType = lobbyType
    self.startTime = startTime
    self.heroID = heroID
    self.version = version
    self.kills = kills
    self.deaths = deaths
    self.assists = assists
    self.skill = skill
    self.leaverStatus = leaverStatus
    self.partySize = partySize
    self.item0 = item0
    self.item1 = item1
    self.item2 = item2
    self.item3 = item3
    self.item4 = item4
    self.item5 = item5
    self.backpack0 = backpack0
    self.lastHits = lastHits
    self.heroHealing = heroHealing
    self.xpPerMin = xpPerMin
    self.goldPerMin = goldPerMin
    self.heroDamage = heroDamage
    self.towerDamage = towerDamage
  }

  enum CodingKeys: String, CodingKey {
    case neutralItem = "item_neutral"
    case matchID = "match_id"
    case playerSlot = "player_slot"
    case radiantWin = "radiant_win"
    case duration
    case gameMode = "game_mode"
    case lobbyType = "lobby_type"
    case startTime = "start_time"
    case heroID = "hero_id"
    case version, kills, deaths, assists, skill
    case leaverStatus = "leaver_status"
    case partySize = "party_size"
    case item0 = "item_0"
    case item1 = "item_1"
    case item2 = "item_2"
    case item3 = "item_3"
    case item4 = "item_4"
    case item5 = "item_5"
    case backpack0 = "backpack_0"
    case xpPerMin = "xp_per_min"
    case goldPerMin = "gold_per_min"
    case heroDamage = "hero_damage"
    case towerDamage = "tower_damage"
    case heroHealing = "hero_healing"
    case lastHits = "last_hits"
  }
}

extension Match: Identifiable {
  public var id: Int {
    matchID
  }
}

#if DEBUG
extension Match {
  public static func fixture(radiantWin: Bool = true) -> Match {
    Match(
      matchID: 6054173905,
      playerSlot: 3,
      radiantWin: radiantWin,
      duration: 2533,
      gameMode: 22,
      lobbyType: 7,
      startTime: 1624390061,
      heroID: 96,
      version: 21,
      kills: 3,
      deaths: 2,
      assists: 24,
      skill: nil,
      leaverStatus: 0,
      partySize: 1,
      item0: 114,
      item1: 73,
      item2: 1,
      item3: 267,
      item4: 131,
      item5: 63
    )
  }
}
#endif
