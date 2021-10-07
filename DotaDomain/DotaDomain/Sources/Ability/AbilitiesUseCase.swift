import DotaCore
import Foundation

public final class AbilitiesUseCase {
  private let session = URLSession.shared
  private let environment: ENV = .prod
//  URL: https://www.dota2.com/datafeed/herodata?language=english&hero_id=38

  public init() {}

  public func abilities(for heroId: Int) async throws -> [Ability] {
    struct Response: Decodable {
      var result: ResponseResults
    }

    struct ResponseResults: Decodable {
      var data: ResponseData
    }

    struct ResponseData: Decodable {
      var heroes: [Hero]
    }

    struct Hero: Decodable {
      var abilities: [Ability]
    }

    let request = resource(heroID: heroId).toRequest(environment.dota2Feed)
    let response = try await session.fetch(Response.self, request: request, decoder: JSONDecoder())

    if response.result.data.heroes.isEmpty {
      throw CoreError.other("No Heroes")
    }

    return response.result.data.heroes[0].abilities
  }

  private func resource(heroID: Int) -> Resource {
    Resource(
      path: "herodata",
      method: .GET,
      query: [
        URLQueryItem(name: "hero_id", value: "\(heroID)"),
        URLQueryItem(name: "language", value: "english")
      ]
    )
  }
}
