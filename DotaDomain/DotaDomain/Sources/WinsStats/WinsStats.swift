import Foundation

public struct WinsStats: Equatable, Codable {
  public var win: Int
  public var lose: Int

  public init(win: Int, lose: Int) {
    self.win = win
    self.lose = lose
  }
}
