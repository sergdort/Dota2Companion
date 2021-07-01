import Foundation
import Combine

public struct Hero: Equatable, Codable {
  public init(
    id: Int,
    name: String,
    localizedName: String,
    primaryAttr: PrimaryAttr,
    attackType: AttackType,
    roles: [Role],
    img: String,
    icon: String,
    baseHealth: Int,
    baseHealthRegen: Double? = nil,
    baseMana: Int,
    baseManaRegen: Double,
    baseArmor: Double,
    baseMr: Int,
    baseAttackMin: Int,
    baseAttackMax: Int,
    baseStr: Int,
    baseAgi: Int,
    baseInt: Int,
    strGain: Double,
    agiGain: Double,
    intGain: Double,
    attackRange: Int,
    projectileSpeed: Int,
    attackRate: Double,
    moveSpeed: Int,
    turnRate: Double? = nil,
    cmEnabled: Bool,
    legs: Int
  ) {
    self.id = id
    self.name = name
    self.localizedName = localizedName
    self.primaryAttr = primaryAttr
    self.attackType = attackType
    self.roles = roles
    self.img = img
    self.icon = icon
    self.baseHealth = baseHealth
    self.baseHealthRegen = baseHealthRegen
    self.baseMana = baseMana
    self.baseManaRegen = baseManaRegen
    self.baseArmor = baseArmor
    self.baseMr = baseMr
    self.baseAttackMin = baseAttackMin
    self.baseAttackMax = baseAttackMax
    self.baseStr = baseStr
    self.baseAgi = baseAgi
    self.baseInt = baseInt
    self.strGain = strGain
    self.agiGain = agiGain
    self.intGain = intGain
    self.attackRange = attackRange
    self.projectileSpeed = projectileSpeed
    self.attackRate = attackRate
    self.moveSpeed = moveSpeed
    self.turnRate = turnRate
    self.cmEnabled = cmEnabled
    self.legs = legs
  }

  public var id: Int
  public var name, localizedName: String
  public var primaryAttr: PrimaryAttr
  public var attackType: AttackType
  public var roles: [Role]
  public var img, icon: String
  public var baseHealth: Int
  public var baseHealthRegen: Double?
  public var baseMana: Int
  public var baseManaRegen, baseArmor: Double
  public var baseMr, baseAttackMin, baseAttackMax, baseStr: Int
  public var baseAgi, baseInt: Int
  public var strGain, agiGain, intGain: Double
  public var attackRange, projectileSpeed: Int
  public var attackRate: Double
  public var moveSpeed: Int
  public var turnRate: Double?
  public var cmEnabled: Bool
  public var legs: Int

  enum CodingKeys: String, CodingKey {
    case id, name
    case localizedName = "localized_name"
    case primaryAttr = "primary_attr"
    case attackType = "attack_type"
    case roles, img, icon
    case baseHealth = "base_health"
    case baseHealthRegen = "base_health_regen"
    case baseMana = "base_mana"
    case baseManaRegen = "base_mana_regen"
    case baseArmor = "base_armor"
    case baseMr = "base_mr"
    case baseAttackMin = "base_attack_min"
    case baseAttackMax = "base_attack_max"
    case baseStr = "base_str"
    case baseAgi = "base_agi"
    case baseInt = "base_int"
    case strGain = "str_gain"
    case agiGain = "agi_gain"
    case intGain = "int_gain"
    case attackRange = "attack_range"
    case projectileSpeed = "projectile_speed"
    case attackRate = "attack_rate"
    case moveSpeed = "move_speed"
    case turnRate = "turn_rate"
    case cmEnabled = "cm_enabled"
    case legs
  }
  static func orderedById(lhs: Hero, rhs: Hero) -> Bool {
    return lhs.id < rhs.id
  }
}

public enum AttackType: String, Codable {
  case melee = "Melee"
  case ranged = "Ranged"
}

public enum PrimaryAttr: String, Codable {
  case agi
  case int
  case str
}

public enum Role: String, Codable {
  case carry = "Carry"
  case disabler = "Disabler"
  case durable = "Durable"
  case escape = "Escape"
  case initiator = "Initiator"
  case jungler = "Jungler"
  case nuker = "Nuker"
  case pusher = "Pusher"
  case support = "Support"
}

typealias Heroes = [String: Hero]

#if DEBUG

extension Hero {
  public static func fixture() -> Hero {
    Hero(
      id: 1,
      name: "npc_dota_hero_antimage",
      localizedName: "Anti-Mage",
      primaryAttr: .agi,
      attackType: .melee,
      roles: [.carry, .escape, .nuker],
      img: "/apps/dota2/images/heroes/antimage_full.png",
      icon: "/apps/dota2/images/heroes/antimage_icon.png",
      baseHealth: 200,
      baseHealthRegen: 0.25,
      baseMana: 75,
      baseManaRegen: 0,
      baseArmor: 0,
      baseMr: 25,
      baseAttackMin: 29,
      baseAttackMax: 33,
      baseStr: 23,
      baseAgi: 24,
      baseInt: 12,
      strGain: 1.3,
      agiGain: 2.8,
      intGain: 1.8,
      attackRange: 150,
      projectileSpeed: 0,
      attackRate: 1.4,
      moveSpeed: 310,
      turnRate: nil,
      cmEnabled: true,
      legs: 2
    )
  }
}

#endif
