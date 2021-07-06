import CombineFeedback
import SwiftUI
import DotaDomain

enum MatchesUI {
  struct RootView: View {
    let store: Store<State, Event>

    var body: some View {
      WithViewContext(store: store) { context in
        MatchesList(data: context.matches)
      }
    }
  }

  static func reducer(state: inout State, event: Event) {
    switch event {
    case .didLoad(let matches):
      state.matches = matches
      state.isLoading = false
    case .didFail(let error):
      state.isLoading = false
      state.error = error as NSError
    }
  }

  static var feedbacks: Feedback<State, Event, Dependencies> {
    return .combine(
      .whenInitialized(just: { depency in
        Event.didLoad(depency.useCase.matches())
      }),
      .predicate(predicate: \.isLoading) { _, dependency in
        do {
          return Event.didLoad(try await dependency.useCase.fetchMatches())
        } catch {
          return Event.didFail(error)
        }
      }
    )
  }

  struct Dependencies {
    var useCase: MatchesUseCase
  }

  struct State: Equatable {
    var matches: [MatchData] = []
    var isLoading: Bool = false
    var error: NSError? = nil
  }

  enum Event {
    case didLoad([MatchData])
    case didFail(Error)
  }
}
