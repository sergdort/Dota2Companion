
public final class MatchesUseCase {
  private let matchesRepo = MatchRepository()
  private let heroesRepo = HeroRepository()
  private let itemsRepo = ItemsRepository()

  public init() {}

  public func matches() -> [MatchData] {
    let matches = matchesRepo.matches()

    return matches.compactMap { match in
      heroesRepo.heroes.findBy(id: match.heroID).map {
        MatchData(
          hero: $0,
          match: match,
          items: match.itemsIds.compactMap(itemsRepo.item(for:))
        )
      }
    }
  }

  public func fetchMatches() async throws -> [MatchData] {
    let matches = try await matchesRepo.fetchMatches()
    return matches.compactMap { match in
      heroesRepo.heroes.findBy(id: match.heroID).map {
        MatchData(
          hero: $0,
          match: match,
          items: match.itemsIds.compactMap(itemsRepo.item(for:))
        )
      }
    }
  }
}

public struct MatchData: Equatable {
  public var hero: Hero
  public var match: Match
  public var items: [Item]
}

