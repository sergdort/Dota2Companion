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
      Feedback(predicate: \.isLoading) { _ in
        repository.getPlayer()
          .zip(repository.winLoses())
          .map { tuple in
            Event.didLoad(tuple.0, repository.rankImage(for: tuple.0), tuple.1)
          }
          .replaceError(replace: Event.didFail)
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
