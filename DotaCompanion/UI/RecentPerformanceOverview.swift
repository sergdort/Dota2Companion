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
        winRate: context.recentPerformance.winRate,
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
    case update(DataSourceBase<RecentPerformance>.State)
  }

  final class ViewModel: Store<State, Event> {
    init() {
      let dataSource = RecentPerformanceRepository().recentPerformance()
      let initialState: State
      switch dataSource.state {
      case let .value(value):
        initialState = State(recentPerformance: value, isLoading: false)
      case .loading:
        initialState = State()
      case let .failed:
        initialState = State(recentPerformance: .empty, isLoading: false)
      }
      super.init(
        initial: initialState,
        feedbacks: [
          Self.whenLoading(dataSource: dataSource)
        ],
        reducer: Self.reducer
      )
    }

    private static func whenLoading(
      dataSource: DataSourceBase<RecentPerformance>
    ) -> Feedback<State, Event> {
      return .observing(source: dataSource.$state, as: Event.update)
    }

    private static func reducer(state: inout State, event: Event) {
      switch event {
      case let .update(.value(recentPerformance)):
        state.recentPerformance = recentPerformance
      case .update(.failed(<#T##CoreError#>))
      }
    }
  }
}
