import Combine
import CombineFeedback
import DotaDomain
import Foundation
import SwiftUI

enum RecentPerformanceUI {
  struct State: Equatable {
    var recentPerformance: RecentPerformance = .empty
    var isLoading = true
    var error: NSError?
  }

  enum Event {
    case didLoad(RecentPerformance)
    case didFail(Error)
  }

  struct Dependency {
    let repository: RecentPerformanceRepository
  }

  static var reducer: Reducer<State, Event> {
    .init { state, event in
      switch event {
      case let .didLoad(performance):
        state.recentPerformance = performance
        state.isLoading = false
      case let .didFail(error):
        state.isLoading = false
        state.error = error as NSError
      }
    }
  }

  static var feedbacks: Feedback<State, Event, Dependency> {
    return .combine(
      .whenInitialized(maybe: { dependency in
        dependency.repository.recentPerformance()
          .map(Event.didLoad)
      }),
      .predicate(predicate: \.isLoading) { _, dependency in
        do {
          return Event.didLoad(try await dependency.repository.fetchRecentPerformance())
        } catch {
          return Event.didFail(error)
        }
      }
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
}
