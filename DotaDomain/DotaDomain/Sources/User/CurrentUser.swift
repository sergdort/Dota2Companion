import Foundation

public enum CurrentUser {
  public static var currentUserId: Int {
    set {
      UserDefaults.standard.set(newValue, forKey: "CurrentUser")
    }
    get {
      UserDefaults.standard.integer(forKey: "CurrentUser")
    }
  }
}
