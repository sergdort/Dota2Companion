import Combine
import SwiftUI
import CombineFeedback
import DotaDomain
import DotaCore

enum PlayerUI {
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

  struct Dependency {
    let player: PlayerRepository
    let winStats: WinsStatsRepository
  }

  static var reducer: Reducer<State, Event> {
    Reducer(reduce: Self.reduce(state:event:))
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

  static var feedbacks: Feedback<State, Event, Dependency> {
    .combine(
      Feedback.whenInitialized(maybe: { dependency in
        if let player = dependency.player.player(),
           let winsStats = dependency.winStats.winLose()
        {
          return Event.didLoad(
            player,
            dependency.player.rankImage(for: player),
            winsStats
          )
        }
        return nil
      }),
      Feedback.predicate(predicate: \.isLoading) { _, dependency in
        do {
          async let player = try await dependency.player.fetchPlayer()
          async let winStats = try await dependency.winStats.fetchWinLoses()
          let playerSync = try await player
          let rankIcon = dependency.player.rankImage(for: playerSync)

          return Event.didLoad(playerSync, rankIcon, try await winStats)
        } catch {
          return Event.didFail(CoreError.other(""))
        }
      }
    )
  }

  struct RootView: View {
    @Environment(\.imageFetcher)
    private var imageFetcher
    let store: Store<PlayerUI.State, PlayerUI.Event>

    public var body: some View {
      WithViewContext(store: store) { context in
        PlayerView(
          image: (
            imageFetcher.image(for: context.player.profile.avatarmedium)
              .ignoreError(),
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
