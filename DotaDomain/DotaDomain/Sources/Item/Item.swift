import Foundation

public struct Item: Codable, Equatable {
  public var hint: [String]?
  public var id: Int
  public var img: String
  public var dname: String?
  public var qual: String?
  public var cost: Int?
  public var notes: String
  public var attrib: [Attrib]
  public var mc: Int?
  public var cd: Int?
  public var lore: String
  public var components: [String]?
  public var charges: Int?
  public var created: Bool

  public init(
    hint: [String],
    id: Int,
    img: String,
    dname: String,
    qual: String,
    cost: Int?,
    notes: String,
    attrib: [Attrib],
    mc: Int?,
    cd: Int?,
    lore: String,
    components: [String],
    created: Bool,
    charges: Int?
  ) {
    self.hint = hint
    self.id = id
    self.img = img
    self.dname = dname
    self.qual = qual
    self.cost = cost
    self.notes = notes
    self.attrib = attrib
    self.mc = mc
    self.cd = cd
    self.lore = lore
    self.components = components
    self.created = created
    self.charges = charges
  }
}

public struct Attrib: Codable, Equatable {
  public var key, header, value: String
  public var footer: String?
}

extension Item: Identifiable {}

#if DEBUG
extension Item {
  public static func fixture() -> Item {
    Item(
      hint: [],
      id: 0,
      img: "/apps/dota2/images/items/blink_lg.png?t=1593393829403",
      dname: "Blink Dagger",
      qual: "component",
      cost: 2250,
      notes: "",
      attrib: [],
      mc: nil,
      cd: 12,
      lore: "",
      components: [],
      created: false,
      charges: nil
    )
  }
}
#endif
