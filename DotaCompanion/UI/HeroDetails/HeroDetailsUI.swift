import Foundation
import DotaDomain
import SwiftUI
import CombineFeedback

enum HeroDetailsUI {
  struct RootView: View {
    let store: Store<State, Event>

    var body: some View {
      WithViewContext(store: store) { context in
        ScrollView {
          VStack {
            HeroDetailsView(hero: context.hero)
            RecentPerformanceView(
              winRate: context.recentPerformance.winRate,
              kills: context.recentPerformance.kills,
              deaths: context.recentPerformance.deaths,
              assists: context.recentPerformance.assists
            )
            .redacted(reason: context.isLoading ? .placeholder : [])
          }
          .padding(.horizontal)
        }
        .background(Colors.backgroundFront.color)
        .navigationBarTitle(context.hero.localizedName, displayMode: .inline)
      }
    }
  }

  static var reducer: Reducer<State, Event> {
    .init { state, event in
      switch event {
      case .didFail(let error):
        print("💀 Error:", error)
        state.isLoading = false
      case .didLoadRecentPerformance(let performance):
        state.recentPerformance = performance
        state.isLoading = false
      }
    }
  }

  static var feedback: Feedback<State, Event, Dependency> {
    .combine(
      .predicate(predicate: \.isLoading, effect: { state, dependency in
        do {
          return Event.didLoadRecentPerformance(
            try await dependency.useCase.fetchRecentPerformance(for: state.hero)
          )
        } catch {
          return Event.didFail(error)
        }
      })
    )
  }

  struct Dependency {
    var useCase: RecentPerformanceUseCase
  }

  struct State: Equatable {
    var hero: Hero
    var recentPerformance: RecentPerformance = .empty
    var isLoading = true
  }

  enum Event {
    case didLoadRecentPerformance(RecentPerformance)
    case didFail(Error)
  }
}
