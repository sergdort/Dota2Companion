import Foundation
import Combine

public struct Hero: Decodable, Identifiable {
    public init(id: Int, name: String, localizedName: String) {
        self.id = id
        self.name = name
        self.localizedName = localizedName
    }
    
    public let id: Int
    public let name: String
    public let localizedName: String
}

public extension Hero {
    func fixture() -> Hero {
        Hero(id: 1, name: "anti_mage", localizedName: "Anti Mage")
    }
}

final class HeroRepository {
    private let baseURL = URL(string: "https://api.steampowered.com/")!
    private let apiKey = "57E8CAA7A2475F676999EDA678884873"
    private let session = URLSession.shared
    
    func getHeroes() -> AnyPublisher<[Hero], Error> {
        struct Response: Decodable {
            let result: Payload
            
            struct Payload: Decodable {
                let heroes: [Hero]
            }
        }
        
        let request = Resource(
            path: "/IEconDOTA2_570/GetHeroes/v0001",
            method: .GET,
            query: [
                "key": apiKey,
                "language": "en_UK"
            ]
        )
        .toRequest(baseURL)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return session
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Response.self, decoder: decoder)
            .map(\.result.heroes)
            .mapError(CoreError.network)
            .eraseToAnyPublisher()
    }
}
