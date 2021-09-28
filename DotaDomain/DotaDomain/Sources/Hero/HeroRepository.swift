import Foundation
import Combine
import DotaCore

final class HeroRepository {
  private let bundle = Bundle(for: ItemsRepository.self)
  let heroes: [Hero]

  init() {
    do {
      let values = try bundle.url(forResource: "Heroes", withExtension: "json")
        .map {
          try Data(contentsOf: $0)
        }.map {
          try $0.decode(Heroes.self, decoder: JSONDecoder())
        }
      self.heroes = values.map(\.values)!.sorted(by: Hero.orderedById(lhs:rhs:))
    } catch {
      fatalError("Failed to parse \(error)")
    }
  }
}
