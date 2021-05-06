import Combine
import Foundation

public final class MatchesRepository {
  private let playerId = CurrentUser.currentUserId
  private let environment: Environment = .prod
  private let session = URLSession.withCache
  private let cache = FileCache(name: "MatchesRepository")


  public func recentMatches() -> AnyPublisher<[Match], CoreError> {
    let resource = Resource(
      path: "players/\(playerId)/recentMatches",
      method: .GET
    )

    return session.dataTaskPublisher(for: resource.toRequest(environment.apiBaseURL))
      .map(\.data)
      .prependAndStore(from: cache, path: resource.path + ".json")
      .decode(type: [Match].self, decoder: JSONDecoder())
      .mapError(CoreError.network)
      .eraseToAnyPublisher()
  }
}
