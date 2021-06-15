
public struct RecentPerformance: Equatable {
  public let numberOfGames: Int
  public let winRate: Double
  public let kills: Value
  public let deaths: Value
  public let assists: Value
  public let gpm: Value
  public let xpm: Value
  public let lastHits: Value
  public let heroDmg: Value
  public let heroHeal: Value
  public let towerDmg: Value

  public struct Value: Equatable {
    public let average: Double
    public let max: Int
    public let maxHero: Hero?

    static var empty: Value {
      Value(average: 0, max: 0, maxHero: nil)
    }
  }

  public init(
    numberOfGames: Int,
    winRate: Double,
    kills: RecentPerformance.Value,
    deaths: RecentPerformance.Value,
    assists: RecentPerformance.Value,
    gpm: RecentPerformance.Value,
    xpm: RecentPerformance.Value,
    lastHits: RecentPerformance.Value,
    heroDmg: RecentPerformance.Value,
    heroHeal: RecentPerformance.Value,
    towerDmg: RecentPerformance.Value
  ) {
    self.numberOfGames = numberOfGames
    self.winRate = winRate
    self.kills = kills
    self.deaths = deaths
    self.assists = assists
    self.gpm = gpm
    self.xpm = xpm
    self.lastHits = lastHits
    self.heroDmg = heroDmg
    self.heroHeal = heroHeal
    self.towerDmg = towerDmg
  }

  public static var empty: RecentPerformance {
    RecentPerformance(
      numberOfGames: 0,
      winRate: 0,
      kills: .empty,
      deaths: .empty,
      assists: .empty,
      gpm: .empty,
      xpm: .empty,
      lastHits: .empty,
      heroDmg: .empty,
      heroHeal: .empty,
      towerDmg: .empty
    )
  }
}
