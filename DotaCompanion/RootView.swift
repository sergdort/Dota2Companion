import Combine
import SwiftUI

public struct RootView: View {
  public var body: some View {
    VStack {
      PlayerOverview.makeRootView()
      RecentPerformanceOverview.makeRootView()
      Spacer()
    }
    .padding()
  }
}
