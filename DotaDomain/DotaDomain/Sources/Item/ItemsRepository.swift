import Foundation
import DotaCore

public final class ItemsRepository {
  private let bundle = Bundle(for: ItemsRepository.self)
  private let idToKeys: [String: String]
  private let keyToItems: [String: Item]

  public init() {
    do {
      self.idToKeys = try bundle.url(forResource: "ItemIds", withExtension: "json")
        .map {
          try Data(contentsOf: $0)
        }
        .map { data in
          try JSONDecoder().decode([String: String].self, from: data)
        } ?? [:]

      self.keyToItems = try bundle.url(forResource: "Items", withExtension: "json")
        .map {
          try Data(contentsOf: $0)
        }
        .map { data in
          try JSONDecoder().decode([String: Item].self, from: data)
        } ?? [:]
    } catch {
      fatalError("Could not initialize, Error, \(error)")
    }
  }

  public func item(for id: Int) -> Item? {
    return idToKeys["\(id)"].flatMap {
      keyToItems[$0]
    }
  }
}
