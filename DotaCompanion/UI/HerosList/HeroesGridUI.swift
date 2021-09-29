import DotaDomain
import CombineFeedback
import SwiftUI

enum HeroesGridUI {

  struct RootView: View {
    let store: Store<State, Event>

    var body: some View {
      WithViewContext(store: store) { context in
        HeroesGridView(heroes: context.heroes)
      }
      .background(Colors.backgroundFront.color)
      .navigationTitle("Heroes")
    }
  }

  static var reducer: Reducer<State, Event> {
    .init { state, event in
      switch event {
      case .didLoad(let heroes):
        state.heroes = heroes
      }
    }
  }

  static var feedbacks: Feedback<State, Event, Dependencies> {
    Feedback.whenInitialized(just: { dependencies in
      Event.didLoad(dependencies.useCase.getHeroes())
    })
  }

  struct Dependencies {
    let useCase: HeroesListUseCase
  }

  struct State: Equatable {
    var heroes: [Hero] = []
  }

  enum Event {
    case didLoad([Hero])
  }
}
