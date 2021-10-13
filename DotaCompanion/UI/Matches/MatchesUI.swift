import CombineFeedback
import SwiftUI
import DotaDomain

enum MatchesUI {
  struct RootView: View {
    let store: Store<State, Event>

    var body: some View {
      WithContextView(store: store) { context in
        MatchesList(data: context.matches)
      }
    }
  }

  static func reducer(state: inout State, event: Event) {
    switch event {
    case .didLoadLocal(let matches):
      state.matches = matches
      state.didGetLocalData = true
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
      .whenInitialized(maybe: { dependency in
        dependency.useCase.matches()
          .map(Event.didLoadLocal)
      }),
      .firstValueAfterNil({ $0.isLoading ? $0 : nil }, effect: { _, dependency in
        do {
          return Event.didLoad(try await dependency.useCase.fetchMatches())
        } catch {
          return Event.didFail(error)
        }
      })
    )
  }

  struct Dependencies {
    var useCase: MatchesUseCase
  }

  struct State: Equatable {
    var matches: [MatchData] = []
    var didGetLocalData = false
    var isLoading: Bool = true
    var error: NSError? = nil
  }

  enum Event {
    case didLoadLocal([MatchData])
    case didLoad([MatchData])
    case didFail(Error)
  }
}
