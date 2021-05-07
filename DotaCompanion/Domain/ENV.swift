import Foundation

public struct ENV {
  public let apiBaseURL: URL
  public let appBaseURL: URL
  public let assetsBaseURL: URL

  public static var prod: ENV {
    ENV(
      apiBaseURL: URL(string: "https://api.opendota.com/api")!,
      appBaseURL: URL(string: "https://www.opendota.com")!,
      assetsBaseURL: URL(string: "https://steamcdn-a.akamaihd.net")!
    )
  }
}
