import Foundation
import CombineFeedback
import CasePaths
import DotaDomain

struct AppState {
  var playerState = PlayerUI.State()
  var recentPerformance = RecentPerformanceUI.State()
}

enum AppEvent {
  case player(PlayerUI.Event)
  case recentPerformance(RecentPerformanceUI.Event)
}

struct AppDependency {
  let playerRepository = PlayerRepository()
  let recentPerformanceRepository = RecentPerformanceRepository()
  let winsStatsRepository = WinsStatsRepository()
}

let appReducer = Reducer<AppState, AppEvent>.combine(
  PlayerUI.reducer.pullback(
    value: \AppState.playerState,
    event: /AppEvent.player
  ),
  RecentPerformanceUI.reducer.pullback(
    value: \.recentPerformance,
    event: /AppEvent.recentPerformance
  )
)

let appFeedbacks = Feedback<AppState, AppEvent, AppDependency>.combine(
  PlayerUI.feedbacks.pullback(
    value: \AppState.playerState,
    event: /AppEvent.player,
    dependency: {
      PlayerUI.Dependency(
        player: $0.playerRepository,
        winStats: $0.winsStatsRepository
      )
    }
  ),
  RecentPerformanceUI.feedbacks.pullback(
    value: \AppState.recentPerformance,
    event: /AppEvent.recentPerformance,
    dependency: {
      RecentPerformanceUI.Dependency(repository: $0.recentPerformanceRepository)
    }
  )
)
