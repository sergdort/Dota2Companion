import Foundation

public struct Environment {
  public let apiBaseURL: URL
  public let appBaseURL: URL

  public static var prod: Environment {
    Environment(
      apiBaseURL: URL(string: "https://api.opendota.com/api")!,
      appBaseURL: URL(string: "https://www.opendota.com")!
    )
  }
}
