import SwiftUI

enum Colors: String {
  case backgroundFront = "background_front"
  case textMain = "text_main"
  case textSecondary = "text_secondary"
  case win
  case lose
  case gold
  
  private final class BundleFinder {}
  
  var color: Color {
    Color(self.rawValue, bundle: Bundle(for: BundleFinder.self))
  }
  
  var uiColor: UIColor {
    UIColor(named: self.rawValue, in: Bundle(for: BundleFinder.self), compatibleWith: nil)!
  }
}

extension Colors: View {
  var body: some View {
    color
  }
}

