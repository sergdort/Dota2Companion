import Combine
import SwiftUI
import CombineFeedback
import DotaDomain
import DotaCore

enum PlayerOverview {
  static func makeRootView() -> some View {
    RootView(
      store: Store(
        initial: State(),
        feedbacks: [],
        reducer: .init(reduce: Self.reduce),
        dependency: ()
      )
    )
  }

  struct State: Equatable {
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

  struct RootView: View {
    @Environment(\.imageFetcher)
    private var imageFetcher
    let store: Store<PlayerOverview.State, PlayerOverview.Event>

    public var body: some View {
      WithViewContext(store: store) { context in
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
}
