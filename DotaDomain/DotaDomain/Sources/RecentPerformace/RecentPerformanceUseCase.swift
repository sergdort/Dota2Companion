import Combine

public final class RecentPerformanceUseCase {
  private let matchesRepo = MatchRepository()
  private let heroesRepo = HeroRepository()

  public init() {}

  public func recentPerformance() -> RecentPerformance? {
    return matchesRepo.matches().map {
      makeRecentPerformance(heroes: heroesRepo.heroes, matches: $0)
    }
  }

  public func fetchRecentPerformance() async throws -> RecentPerformance {
    let matches = try await matchesRepo.fetchMatches()
    return makeRecentPerformance(heroes: heroesRepo.heroes, matches: matches)
  }

  public func fetchRecentPerformance(for hero: Hero) async throws -> RecentPerformance {
    let matches = try await matchesRepo.fetchMatches(heroId: hero.id)
    return makeRecentPerformance(heroes: heroesRepo.heroes, matches: matches)
  }

  private func makeRecentPerformance(
    heroes: [Hero],
    matches: [Match]
  ) -> RecentPerformance {
    if matches.isEmpty {
      return .empty
    }
    let numberOfGames = matches.count
    let winsCount = matches.reduce(0) { acum, match in
      acum + (match.isWin ? 1 : 0)
    }
    let winRate = Double(winsCount) / Double(numberOfGames)

    let averageKills = matches.average(by: \.kills)
    let maxKillsMatch = matches.max(by: \.kills)!

    let averageDeaths = matches.average(by: \.deaths)
    let maxDeathsMatch = matches.max(by: \.deaths)!

    let averageAssists = matches.average(by: \.assists)
    let maxAssistsMatch = matches.max(by: \.assists)!

    let averageGPM = matches.average(by: \.goldPerMin)
    let maxGPMMatch = matches.max(by: \.goldPerMin, defaultValue: 0)!

    let averageXPM = matches.average(by: \.xpPerMin)
    let maxXPMMatch = matches.max(by: \.xpPerMin, defaultValue: 0)!

    let averageLastHits = matches.average(by: \.lastHits)
    let maxLastHitsMatch = matches.max(by: \.lastHits, defaultValue: 0)!

    let averageHeroDmg = matches.average(by: \.heroDamage)
    let maxHeroDMGMatch = matches.max(by: \.heroDamage, defaultValue: 0)!

    let averageHeroHeal = matches.average(by: \.heroHealing)
    let maxHeroHealMatch = matches.max(by: \.heroHealing, defaultValue: 0)!

    let averageTowerDmg = matches.average(by: \.towerDamage)
    let maxTowerDmgMatch = matches.max(by: \.towerDamage, defaultValue: 0)!

    return RecentPerformance(
      numberOfGames: numberOfGames,
      winRate: winRate,
      kills: RecentPerformance.Value(
        average: averageKills,
        max: maxKillsMatch.kills,
        maxHero: heroes.findBy(id: maxKillsMatch.heroID)
      ),
      deaths: RecentPerformance.Value(
        average: averageDeaths,
        max: maxDeathsMatch.deaths,
        maxHero: heroes.findBy(id: maxDeathsMatch.heroID)
      ),
      assists: RecentPerformance.Value(
        average: averageAssists,
        max: maxAssistsMatch.assists,
        maxHero: heroes.findBy(id: maxAssistsMatch.heroID)
      ),
      gpm: RecentPerformance.Value(
        average: averageGPM,
        max: maxGPMMatch.goldPerMin ?? 0,
        maxHero: heroes.findBy(id: maxGPMMatch.heroID)
      ),
      xpm: RecentPerformance.Value(
        average: averageXPM,
        max: maxXPMMatch.xpPerMin ?? 0,
        maxHero: heroes.findBy(id: maxXPMMatch.heroID)
      ),
      lastHits: RecentPerformance.Value(
        average: averageLastHits,
        max: maxLastHitsMatch.lastHits ?? 0,
        maxHero: heroes.findBy(id: maxLastHitsMatch.heroID)
      ),
      heroDmg: RecentPerformance.Value(
        average: averageHeroDmg,
        max: maxHeroDMGMatch.heroDamage ?? 0,
        maxHero: heroes.findBy(id: maxHeroDMGMatch.heroID)
      ),
      heroHeal: RecentPerformance.Value(
        average: averageHeroHeal,
        max: maxHeroHealMatch.heroHealing ?? 0,
        maxHero: heroes.findBy(id: maxHeroHealMatch.heroID)
      ),
      towerDmg: RecentPerformance.Value(
        average: averageTowerDmg,
        max: maxTowerDmgMatch.towerDamage ?? 0,
        maxHero: heroes.findBy(id: maxTowerDmgMatch.heroID)
      )
    )
  }
}

extension Array where Element == Hero {
  func findBy(id: Int) -> Hero? {
    first(where: { $0.id == id })
  }
}

extension Array {
  func sum(by keyPath: KeyPath<Element, Int>) -> Int {
    return reduce(0) { acum, element in
      acum + element[keyPath: keyPath]
    }
  }

  func average(by keyPath: KeyPath<Element, Int>) -> Double {
    if isEmpty {
      return 0
    }
    return Double(sum(by: keyPath)) / Double(count)
  }

  func max<Attribute: Comparable>(by keyPath: KeyPath<Element, Attribute>) -> Element? {
    self.max(by: { lhs, rhs in lhs[keyPath: keyPath] < rhs[keyPath: keyPath] })
  }

  func sum(by keyPath: KeyPath<Element, Int?>) -> Int {
    return reduce(0) { acum, element in
      acum + (element[keyPath: keyPath] ?? 0)
    }
  }

  func average(by keyPath: KeyPath<Element, Int?>) -> Double {
    if isEmpty {
      return 0
    }
    return Double(sum(by: keyPath)) / Double(count)
  }

  func max<Attribute: Comparable>(
    by keyPath: KeyPath<Element, Attribute?>,
    defaultValue: Attribute
  ) -> Element? {
    self.max(by: { lhs, rhs in (lhs[keyPath: keyPath] ?? defaultValue) < (rhs[keyPath: keyPath] ?? defaultValue) })
  }
}
