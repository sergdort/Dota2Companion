import Combine

public final class MatchesRepository {
  public func recentMatches() -> AnyPublisher<[Match], CoreError> {
    Empty().eraseToAnyPublisher()
  }
}
