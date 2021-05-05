import Foundation
import Combine

struct Hero: Codable {
  var id: Int
  var name, localizedName: String
  var primaryAttr: PrimaryAttr
  var attackType: AttackType
  var roles: [Role]
  var img, icon: String
  var baseHealth: Int
  var baseHealthRegen: Double?
  var baseMana: Int
  var baseManaRegen, baseArmor: Double
  var baseMr, baseAttackMin, baseAttackMax, baseStr: Int
  var baseAgi, baseInt: Int
  var strGain, agiGain, intGain: Double
  var attackRange, projectileSpeed: Int
  var attackRate: Double
  var moveSpeed: Int
  var turnRate: Double?
  var cmEnabled: Bool
  var legs: Int

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
}

enum AttackType: String, Codable {
  case melee = "Melee"
  case ranged = "Ranged"
}

enum PrimaryAttr: String, Codable {
  case agi
  case int
  case str
}

enum Role: String, Codable {
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

final class HeroRepository {
  private let url = URL(string: "https://raw.githubusercontent.com/odota/dotaconstants/master/build/heroes.json")!
  private let session = URLSession.shared
  private let fileCache = FileCache(name: "HeroRepository")

  func getHeroes() -> AnyPublisher<[Hero], CoreError> {
    return Deferred { () -> AnyPublisher<[Hero], CoreError> in
      if let data = try? self.fileCache.loadFile(path: ""),
         let heroes = try? JSONDecoder().decode(Heroes.self, from: data) {
          return Result.Publisher(heroes.values.sorted(by: orderedById))
            .eraseToAnyPublisher()
      }
      return self.session
        .dataTaskPublisher(for: self.url)
        .map(\.data)
        .handleEvents(receiveOutput: { data in
          try? self.fileCache.persist(data: data, path: "")
        })
        .decode(type: Heroes.self, decoder: JSONDecoder())
        .map {
          $0.values.sorted(by: orderedById)
        }
        .mapError(CoreError.network)
        .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
  }
}

func orderedById(lhs: Hero, rhs: Hero) -> Bool {
  return lhs.id < rhs.id
}
