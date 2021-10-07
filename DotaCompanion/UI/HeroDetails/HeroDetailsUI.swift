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
            if let selectedAbility = context.selectedAbility, context.abilities.isNotEmpty {
              AbilitiesView(
                abilities: context.abilities,
                selectedAbility: Binding(
                  get: {
                    selectedAbility
                  },
                  set: { ability in
                    context.send(event: .didSelectAbility(ability))
                  }
                )
              )
              VideoView(asset: selectedAbility.videoAsset(hero: context.hero))
                .aspectRatio(CGSize(width: 814, height: 458), contentMode: .fill)
            }
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
      case .didLoad(let performance, let abilities):
        state.recentPerformance = performance
        state.abilities = abilities
        state.selectedAbility = abilities[0]
        state.isLoading = false
      case .didSelectAbility(let ability):
        state.selectedAbility = ability
      }
    }
  }

  static var feedback: Feedback<State, Event, Dependency> {
    .combine(
      .predicate(predicate: \.isLoading, effect: { state, dependency in
        do {
          async let performance = dependency.recentPerformance.fetchRecentPerformance(for: state.hero)
          async let abilities = dependency.abilities.abilities(for: state.hero.id)
          return Event.didLoad(
            try await performance, try await abilities
          )
        } catch {
          return Event.didFail(error)
        }
      })
    )
  }

  struct Dependency {
    var recentPerformance: RecentPerformanceUseCase
    var abilities: AbilitiesUseCase
  }

  struct State: Equatable {
    var hero: Hero
    var recentPerformance: RecentPerformance = .empty
    var isLoading = true
    var abilities: [Ability] = []
    var selectedAbility: Ability?
  }

  enum Event {
    case didLoad(RecentPerformance, [Ability])
    case didFail(Error)
    case didSelectAbility(Ability)
  }
}
