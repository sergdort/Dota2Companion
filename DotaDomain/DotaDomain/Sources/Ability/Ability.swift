import Combine
import UIKit
import DotaCore
import AVFoundation

public struct Ability: Codable {
  public var id: Int
  public var name, nameLOC, descLOC, loreLOC: String
  public var notesLOC: [String]
  public var shardLOC, scepterLOC: String
  public var type: Int
  public var behavior: String
  public var targetTeam, targetType, flags, damage: Int
  public var immunity, dispellable, maxLevel: Int
  public var castRanges: [Int]
  public var castPoints: [Double]
  public var channelTimes, cooldowns, durations, damages: [Int]
  public var manaCosts: [Int]
  public var specialValues: [SpecialValue]
  public var isItem, abilityHasScepter, abilityHasShard, abilityIsGrantedByScepter: Bool
  public var abilityIsGrantedByShard: Bool
  public var itemCost, itemInitialCharges, itemNeutralTier, itemStockMax: Int
  public var itemStockTime, itemQuality: Int

  public init(
    id: Int,
    name: String,
    nameLOC: String,
    descLOC: String,
    loreLOC: String,
    notesLOC: [String],
    shardLOC: String,
    scepterLOC: String,
    type: Int,
    behavior: String,
    targetTeam: Int,
    targetType: Int,
    flags: Int,
    damage: Int,
    immunity: Int,
    dispellable: Int,
    maxLevel: Int,
    castRanges: [Int],
    castPoints: [Double],
    channelTimes: [Int],
    cooldowns: [Int],
    durations: [Int],
    damages: [Int],
    manaCosts: [Int],
    specialValues: [SpecialValue],
    isItem: Bool,
    abilityHasScepter: Bool,
    abilityHasShard: Bool,
    abilityIsGrantedByScepter: Bool,
    abilityIsGrantedByShard: Bool,
    itemCost: Int,
    itemInitialCharges: Int,
    itemNeutralTier: Int,
    itemStockMax: Int,
    itemStockTime: Int,
    itemQuality: Int
  ) {
    self.id = id
    self.name = name
    self.nameLOC = nameLOC
    self.descLOC = descLOC
    self.loreLOC = loreLOC
    self.notesLOC = notesLOC
    self.shardLOC = shardLOC
    self.scepterLOC = scepterLOC
    self.type = type
    self.behavior = behavior
    self.targetTeam = targetTeam
    self.targetType = targetType
    self.flags = flags
    self.damage = damage
    self.immunity = immunity
    self.dispellable = dispellable
    self.maxLevel = maxLevel
    self.castRanges = castRanges
    self.castPoints = castPoints
    self.channelTimes = channelTimes
    self.cooldowns = cooldowns
    self.durations = durations
    self.damages = damages
    self.manaCosts = manaCosts
    self.specialValues = specialValues
    self.isItem = isItem
    self.abilityHasScepter = abilityHasScepter
    self.abilityHasShard = abilityHasShard
    self.abilityIsGrantedByScepter = abilityIsGrantedByScepter
    self.abilityIsGrantedByShard = abilityIsGrantedByShard
    self.itemCost = itemCost
    self.itemInitialCharges = itemInitialCharges
    self.itemNeutralTier = itemNeutralTier
    self.itemStockMax = itemStockMax
    self.itemStockTime = itemStockTime
    self.itemQuality = itemQuality
  }


  enum CodingKeys: String, CodingKey {
    case id, name
    case nameLOC = "name_loc"
    case descLOC = "desc_loc"
    case loreLOC = "lore_loc"
    case notesLOC = "notes_loc"
    case shardLOC = "shard_loc"
    case scepterLOC = "scepter_loc"
    case type, behavior
    case targetTeam = "target_team"
    case targetType = "target_type"
    case flags, damage, immunity, dispellable
    case maxLevel = "max_level"
    case castRanges = "cast_ranges"
    case castPoints = "cast_points"
    case channelTimes = "channel_times"
    case cooldowns, durations, damages
    case manaCosts = "mana_costs"
    case specialValues = "special_values"
    case isItem = "is_item"
    case abilityHasScepter = "ability_has_scepter"
    case abilityHasShard = "ability_has_shard"
    case abilityIsGrantedByScepter = "ability_is_granted_by_scepter"
    case abilityIsGrantedByShard = "ability_is_granted_by_shard"
    case itemCost = "item_cost"
    case itemInitialCharges = "item_initial_charges"
    case itemNeutralTier = "item_neutral_tier"
    case itemStockMax = "item_stock_max"
    case itemStockTime = "item_stock_time"
    case itemQuality = "item_quality"
  }
}

public extension Ability {
  func icon(imageFetcher: ImageFetcher) -> AnyPublisher<UIImage, Never> {
    let url = URL(
      string: ENV.prod.dota2CDN.absoluteString + "/images/dota_react/abilities/" + name + ".png"
    )!
    return imageFetcher.image(
      for: url
    )
    .ignoreError()
  }

  func videoPlaceHolder(imageFetcher: ImageFetcher) -> AnyPublisher<UIImage, Never> {
    let url = URL(
      string: ENV.prod.dota2CDN.absoluteString + "/videos/dota_react/abilities/" + name + ".png"
    )!
    return imageFetcher.image(
      for: url
    )
    .ignoreError()
  }

  func videoAsset() -> AVAsset {
    AVURLAsset(
      url: URL(
        string: ENV.prod.dota2CDN.absoluteString + "/videos/dota_react/abilities/" + name + ".mp4"
      )!
    )
  }
}

#if DEBUG

public extension Ability {
  static func fixture() -> Ability {
    Ability(
      id: 0,
      name: "batrider_sticky_napalm",
      nameLOC: "Sticky Napalm",
      descLOC: "Drenches an area in sticky oil, amplifying damage from Batrider's attacks and abilities and slowing the movement speed and turn rate of enemies in the area.  Additional casts of Sticky Napalm continue to increase damage, up to %max_stacks% stacks.",
      loreLOC: "It's not uncommon to hear the Rider cackle while he increases the flammability of his opponents.",
      notesLOC: [
        "All damage from Batrider gets amplified, except for Radiance, Orb of Venom, Urn of Shadows, and Spirit Vessel.",
        "Sticky napalm does not require turning to cast."
      ],
      shardLOC: "",
      scepterLOC: "",
      type: 0,
      behavior: "134217776",
      targetTeam: 0,
      targetType: 0,
      flags: 0,
      damage: 0,
      immunity: 4,
      dispellable: 2,
      maxLevel: 4,
      castRanges: [
        550,
        600,
        650,
        700
      ],
      castPoints: [0],
      channelTimes: [
        0,
        0,
        0,
        0
      ],
      cooldowns: [
        3,
        3,
        3,
        3
      ],
      durations: [
        0,
        0,
        0,
        0
      ],
      damages: [
        0,
        0,
        0,
        0
      ],
      manaCosts: [
        20
      ],
      specialValues: [
        SpecialValue(
          name: "damage",
          valuesFloat: [],
          valuesInt: [
            7,
            14,
            21,
            28
          ],
          isPercentage: false,
          headingLOC: "EXTRA DAMAGE:"
        ),
        SpecialValue(
          name: "radius",
          valuesFloat: [],
          valuesInt: [
            375,
            400,
            425,
            450
          ],
          isPercentage: false,
          headingLOC: "RADIUS:"
        ),
        SpecialValue(
          name: "duration",
          valuesFloat: [7],
          valuesInt: [],
          isPercentage: false,
          headingLOC: "DURATION:"
        ),
        SpecialValue(
          name: "movement_speed_pct",
          valuesFloat: [],
          valuesInt: [
            -2,
             -4,
             -6,
             -8
          ],
          isPercentage: true,
          headingLOC: "MOVEMENT SLOW:"
        ),
        SpecialValue(
          name: "turn_rate_pct",
          valuesFloat: [],
          valuesInt: [
            -10,
             -30,
             -50,
             -70
          ],
          isPercentage: true,
          headingLOC: "TURN RATE SLOW:"
        ),
        SpecialValue(
          name: "max_stacks",
          valuesFloat: [],
          valuesInt: [
            10
          ],
          isPercentage: false,
          headingLOC: ""
        ),
        SpecialValue(
          name: "AbilityCastRange",
          valuesFloat: [],
          valuesInt: [
            550,
            600,
            650,
            700
          ],
          isPercentage: false,
          headingLOC: ""
        )
      ],
      isItem: false,
      abilityHasScepter: false,
      abilityHasShard: false,
      abilityIsGrantedByScepter: false,
      abilityIsGrantedByShard: false,
      itemCost: 0,
      itemInitialCharges: 0,
      itemNeutralTier: 4294967295,
      itemStockMax: 0,
      itemStockTime: 0,
      itemQuality: 0
    )
  }
}

#endif

public struct SpecialValue: Codable {
  public var name: String
  public var valuesFloat: [Double]
  public var valuesInt: [Int]
  public var isPercentage: Bool
  public var headingLOC: String
  
  public init(
    name: String,
    valuesFloat: [Double],
    valuesInt: [Int],
    isPercentage: Bool,
    headingLOC: String
  ) {
    self.name = name
    self.valuesFloat = valuesFloat
    self.valuesInt = valuesInt
    self.isPercentage = isPercentage
    self.headingLOC = headingLOC
  }

  enum CodingKeys: String, CodingKey {
    case name
    case valuesFloat = "values_float"
    case valuesInt = "values_int"
    case isPercentage = "is_percentage"
    case headingLOC = "heading_loc"
  }
}

