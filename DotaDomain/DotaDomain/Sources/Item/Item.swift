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
