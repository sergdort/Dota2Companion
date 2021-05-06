import Foundation
import Combine

final class HeroRepository {
  private let url = URL(string: "https://raw.githubusercontent.com/odota/dotaconstants/master/build/heroes.json")!
  private let session = URLSession.withCache
  private let cache = FileCache(name: "HeroRepository")

  func getHeroes() -> AnyPublisher<[Hero], CoreError> {
    return session.dataTaskPublisher(for: url)
      .map(\.data)
      .prependAndStore(from: cache, path: "heroes.json")
      .decode(type: Heroes.self, decoder: JSONDecoder())
      .map {
        $0.values.sorted(by: Hero.orderedById)
      }
      .mapError(CoreError.network)
      .eraseToAnyPublisher()
  }
}
