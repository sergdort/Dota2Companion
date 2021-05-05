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
    var player: Player?
    var rankIcon: RankIcon?
    var isLoading = true
  }

  enum Event {
    case didLoad(Player, RankIcon?)
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
      Feedback(predicate: \.isLoading) { _ in
        repository.getPlayer()
          .map {
            Event.didLoad($0, repository.rankImage(for: $0))
          }
          .replaceError(replace: Event.didFail)
          .receive(on: DispatchQueue.main)
      }
    }

    private static func reduce(state: inout State, event: Event) {
      switch event {
      case .didLoad(let player, let rankIcon):
        state.player = player
        state.rankIcon = rankIcon
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
          context.player.map {
            imageFetcher.image(for: $0.profile.avatarmedium)
          } ?? Empty().eraseToAnyPublisher(),
          nil
        ),
        rankIcon: context.rankIcon,
        name: context.player?.profile.personaname ?? "Placeholder",
        wins: 1527,
        loses: 1764
      )
      .redacted(reason: context.isLoading ? .placeholder : [])
    }
  }
}
