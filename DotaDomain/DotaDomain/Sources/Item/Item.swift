import Foundation

public struct Item: Codable {
  var hint: [String]?
  var id: Int
  var img: String
  var dname: String?
  var qual: String?
  var cost: Int?
  var notes: String
  var attrib: [Attrib]
  var mc: Int?
  var cd: Int?
  var lore: String
  var components: [String]?
  var charges: Int?
  var created: Bool

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

public struct Attrib: Codable {
  public var key, header, value: String
  public var footer: String?
}
