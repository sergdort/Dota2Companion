import Combine
import SwiftUI
import CombineFeedback
import CombineFeedbackUI

enum PlayerOverview {
  static func makeRootView() -> some View {
    CombineFeedbackUI.Widget(
      store: PlayerOverview.ViewModel(),
      content: { context in
        PlayerOverview.RootView(context: context)
      }
    )
  }

  struct State {
    var player = Player(
      rankTier: 0,
      leaderboardRank: nil,
      profile: Player.Profile(
        accountId: 0,
        personaname: "Placeholder",
        avatar: URL(string: "https://github.com/")!,
        avatarmedium: URL(string: "https://github.com/")!,
        avatarfull: URL(string: "https://github.com/")!
      )
    )
    var rankIcon: RankIcon? = nil
    var winStats = WinsStats(win: 1000, lose: 1000)
    var isLoading = true
  }

  enum Event {
    case didLoad(Player, RankIcon?, WinsStats)
    case didFail(CoreError)
  }

  public final class ViewModel: Store<State, Event> {
    init() {
      super.init(
        initial: PlayerOverview.State(),
        feedbacks: [
          Self.whenLoading(repository: PlayerRepository())
        ],
        reducer: Self.reduce(state:event:)
      )
    }

    private static func whenLoading(
      repository: PlayerRepository
    ) -> Feedback<State, Event> {
      .predicateMultiple(predicate: \.isLoading) { _ in
        repository.getPlayer()
          .zip(repository.winLoses())
          .map { tuple in
            Event.didLoad(tuple.0, repository.rankImage(for: tuple.0), tuple.1)
          }
          .replaceError(Event.didFail)
          .receive(on: DispatchQueue.main)
      }
    }

    private static func reduce(state: inout State, event: Event) {
      switch event {
      case let .didLoad(player, rankIcon, winStats):
        state.player = player
        state.rankIcon = rankIcon
        state.winStats = winStats
        state.isLoading = false
      case .didFail:
        state.isLoading = false
      }
    }
  }

  struct RootView: View {
    @ObservedObject
    var context: Context<State, Event>
    @Environment(\.imageFetcher)
    var imageFetcher

    public var body: some View {
      PlayerView(
        image: (
          imageFetcher.image(for: context.player.profile.avatarmedium),
          nil
        ),
        rankIcon: context.rankIcon,
        name: context.player.profile.name ?? context.player.profile.personaname,
        wins: context.winStats.win,
        loses: context.winStats.lose
      )
      .redacted(reason: context.isLoading ? .placeholder : [])
    }
  }
}

extension Feedback {
  static func predicateMultiple<Effect: Publisher>(
    predicate: @escaping (State) -> Bool,
    effects: @escaping (State) -> Effect
  ) -> Feedback where Effect.Failure == Never, Effect.Output == Event {
    return .compactingNotCancelable(
      transform: { $0 },
      effects: { state -> AnyPublisher<Event, Never> in
        predicate(state) ? effects(state).eraseToAnyPublisher() : Empty().eraseToAnyPublisher()
      }
    )
  }

  static func compactingNotCancelable<U, Effect: Publisher>(
    transform: @escaping (AnyPublisher<State, Never>) -> AnyPublisher<U, Never>,
    effects: @escaping (U) -> Effect
  ) -> Feedback where Effect.Output == Event, Effect.Failure == Never {
    custom { state, output in
      transform(state)
        .flatMap {
          effects($0).enqueue(to: output)
        }
        .sink { _ in }
    }
  }

  static func observing<U, Effect: Publisher>(
    source: Effect,
    as f: @escaping (U) -> Event
  ) -> Feedback<State, Event> where Effect.Failure == Never, Effect.Output == U {
    .custom { (_, consumer) -> Cancellable in
      source.map(f).enqueue(to: consumer)
        .sink(receiveValue: { _ in })
    }
  }
}
