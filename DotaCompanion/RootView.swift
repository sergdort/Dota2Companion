import SwiftUI
import CombineFeedback

public struct RootView: View {
  let store: Store<AppState, AppEvent>

  public var body: some View {
    VStack {
      PlayerUI.RootView(
        store: store.scoped(to: \.playerState, event: AppEvent.player)
      )
      RecentPerformanceUI.RootView(
        store: store.scoped(to: \.recentPerformance, event: AppEvent.recentPerformance)
      )
      MatchesUI.RootView(
        store: store.scoped(to: \.matchesState, event: AppEvent.matches)
      )
    }
    .padding()
  }
}
