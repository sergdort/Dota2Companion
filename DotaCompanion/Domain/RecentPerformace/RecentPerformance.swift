
public struct RecentPerformance {
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


  public struct Value {
    public let average: Double
    public let max: Int
    public let maxHero: Hero?

    static var empty: Value {
      Value(average: 0, max: 0, maxHero: nil)
    }
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
