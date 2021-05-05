import Combine
import SwiftUI
import CombineFeedbackUI

public struct RootView: View {
  public var body: some View {
    VStack {
      PlayerOverview.makeRootView()
      Spacer()
    }
    .padding()
  }
}
