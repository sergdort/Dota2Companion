import DotaDomain
import CombineFeedback
import SwiftUI
import CasePaths

enum HeroesGridUI {
  struct RootView: View {
    let store: Store<State, Event>

    var body: some View {
      WithViewContext(store: store) { context in
        HeroesGridView(heroes: context.heroes) { hero in
          context.send(event: Event.didSelect(hero))
        }
        .navigate(using: context.binding(for: \.isNavigationActive, event: Event.didChangeNavigation), destination: makeHeroDetails)
      }
      .background(Colors.backgroundFront.color)
      .navigationTitle("Heroes")
    }

    private func makeHeroDetails() -> some View {
      LazyView {
        IfLetWithViewContext(store: store.scoped(to: \.details, event: HeroesGridUI.Event.details)) { store in
          HeroDetailsUI.RootView(store: store)
        }
      }
    }
  }

  static var reducer: Reducer<State, Event> {
    Reducer<State, Event>.combine(
      mainReducer,
      HeroDetailsUI.reducer
        .optional()
        .pullback(value: \HeroesGridUI.State.details, event: /HeroesGridUI.Event.details)
    )
  }

  private static var mainReducer: Reducer<State, Event> {
    Reducer { state, event in
      switch event {
      case .didLoad(let heroes):
        state.heroes = heroes
      case .didSelect(let hero):
        state.isNavigationActive = true
        state.details = .init(hero: hero)
      case .didChangeNavigation(let isActive):
        state.details = isActive ? state.details : nil
        state.isNavigationActive = isActive
      case .details:
        break
      }
    }
  }

  static var feedbacks: Feedback<State, Event, Dependencies> {
    Feedback.combine(
      Feedback.whenInitialized(just: { dependencies in
        Event.didLoad(dependencies.useCase.getHeroes())
      }),
      HeroDetailsUI.feedback.optional()
        .pullback(
          value: \.details,
          event: /Event.details,
          dependency: { dependency in
            HeroDetailsUI.Dependency(useCase: dependency.recentPerformance)
          }
        )
    )
  }

  struct Dependencies {
    let useCase: HeroesListUseCase
    let recentPerformance: RecentPerformanceUseCase
  }

  struct State: Equatable {
    var heroes: [Hero] = []
    var isNavigationActive: Bool = false
    var details: HeroDetailsUI.State? = nil
  }

  enum Event {
    case didLoad([Hero])
    case didSelect(Hero)
    case didChangeNavigation(Bool)
    case details(HeroDetailsUI.Event)
  }
}

extension View {
  func navigate<Destination: View>(
    using binding: Binding<Bool>,
    @ViewBuilder destination: () -> Destination
  ) -> some View {
    background(NavigationLink(isActive: binding, destination: destination, label: EmptyView.init))
  }

  func background<Content: View>(@ViewBuilder _ builder: () -> Content) -> some View {
    background(builder())
  }
}

struct LazyView<Content: View>: View {
  let build: () -> Content
  init(_ build: @escaping () -> Content) {
    self.build = build
  }

  var body: Content {
    build()
  }
}
