import Combine
import CombineFeedback
import CombineFeedbackUI
import Foundation
import SwiftUI

enum RecentPerformanceOverview {
  static func makeRootView() -> some View {
    CombineFeedbackUI.Widget(
      store: ViewModel(),
      content: RootView.init
    )
  }

  struct RootView: View {
    @ObservedObject
    var context: Context<State, Event>

    var body: some View {
      RecentPerformanceView(
        kills: context.recentPerformance.kills,
        deaths: context.recentPerformance.deaths,
        assists: context.recentPerformance.assists
      )
      .redacted(reason: context.isLoading ? .placeholder : [])
    }
  }


  struct State {
    var recentPerformance: RecentPerformance = .empty
    var isLoading = true
  }

  enum Event {
    case didLoad(RecentPerformance)
    case didFail(CoreError)
  }

  final class ViewModel: Store<State, Event> {
    init() {
      super.init(
        initial: State(),
        feedbacks: [
          Self.whenLoading(repository: RecentPerformanceRepository())
        ],
        reducer: Self.reducer
      )
    }

    private static func whenLoading(
      repository: RecentPerformanceRepository
    ) -> Feedback<State, Event> {
      Feedback(predicate: \.isLoading) { _ in
        repository.recentPerformance()
          .map(Event.didLoad)
          .replaceError(Event.didFail)
          .receive(on: DispatchQueue.main)
      }
    }

    private static func reducer(state: inout State, event: Event) {
      switch event {
      case let .didLoad(performance):
        state.recentPerformance = performance
        state.isLoading = false
      case .didFail:
        break
      }
    }
  }
}
