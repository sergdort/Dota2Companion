import Foundation
import Combine
import DotaCore

final class HeroRepository {
  private let bundle = Bundle(for: ItemsRepository.self)
  let heroes: [Hero]

  init() {
    do {
      self.heroes = try bundle.url(forResource: "Heroes", withExtension: "json")
        .map {
          try Data(contentsOf: $0)
        }.map {
          try $0.decode(Heroes.self, decoder: JSONDecoder())
        }
        .map(\.values)?
        .sorted(by: Hero.orderedById) ?? []
    } catch {
      fatalError("Failed to parse \(error)")
    }
  }
}
