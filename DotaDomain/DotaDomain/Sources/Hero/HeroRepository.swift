import Foundation
import Combine
import DotaCore

final class HeroRepository {
  private let url = URL(string: "https://raw.githubusercontent.com/odota/dotaconstants/master/build/heroes.json")!
  private let session = URLSession.shared
  private let cache = FileCache(name: "HeroRepository")
  private let path = "heroes.json"

  public init() {}

  public func heroes() -> [Hero] {
    do {
      return try cache.loadFile(path: path)
        .decode(Heroes.self, decoder: JSONDecoder())
        .values
        .sorted(by: Hero.orderedById)
    } catch {
      return []
    }
  }

  public func fetchHeroes() async throws -> [Hero] {
    let heroes = try await session.fetch(Heroes.self, request: URLRequest(url: url), decoder: JSONDecoder()
    )
    try cache.persist(item: heroes, encoder: JSONEncoder(), path: path)
    return heroes.values.sorted(by: Hero.orderedById)
  }
}
