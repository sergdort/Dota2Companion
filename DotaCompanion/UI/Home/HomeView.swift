import SwiftUI
import CombineFeedback

struct HomeView: View {
  let store: Store<AppState, AppEvent>

  var body: some View {
    ScrollView {
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
    .background(Colors.backgroundFront.color)
    .navigationTitle("Home")
  }
}
