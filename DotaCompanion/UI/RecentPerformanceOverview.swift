import Combine
import CombineFeedback
import DotaDomain
import Foundation
import SwiftUI

enum RecentPerformanceOverview {
  static func makeRootView() -> some View {
    RootView(
      store: Store<State, Event>(
        initial: State(),
        feedbacks: [],
        reducer: .init(reduce: { _, _ in }),
        dependency: ()
      )
    )
  }

  struct RootView: View {
    let store: Store<State, Event>

    var body: some View {
      WithViewContext(store: store) { context in
        RecentPerformanceView(
          winRate: context.recentPerformance.winRate,
          kills: context.recentPerformance.kills,
          deaths: context.recentPerformance.deaths,
          assists: context.recentPerformance.assists
        )
          .redacted(reason: context.isLoading ? .placeholder : [])
      }
    }
  }

  struct State: Equatable {
    var recentPerformance: RecentPerformance = .empty
    var isLoading = true
  }

  enum Event {
  }
}
