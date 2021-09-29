
public final class HeroesListUseCase {
  private let repo = HeroRepository()

  public init() {}

  public func getHeroes() -> [Hero] {
    repo.heroes
  }
}
