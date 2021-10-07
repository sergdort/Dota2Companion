import Foundation
import CombineFeedback
import CasePaths
import DotaDomain

struct AppState {
  var playerState = PlayerUI.State()
  var recentPerformance = RecentPerformanceUI.State()
  var matchesState = MatchesUI.State()
  var heroes = HeroesGridUI.State()
}

enum AppEvent {
  case player(PlayerUI.Event)
  case recentPerformance(RecentPerformanceUI.Event)
  case matches(MatchesUI.Event)
  case heroes(HeroesGridUI.Event)
}

struct AppDependency {
  let playerRepository = PlayerRepository()
  let recentPerformance = RecentPerformanceUseCase()
  let winsStatsRepository = WinsStatsRepository()
  let matchesUseCase = MatchesUseCase()
  let heroesListUseCase = HeroesListUseCase()
  let abilities = AbilitiesUseCase()
}

let appReducer = Reducer<AppState, AppEvent>.combine(
  PlayerUI.reducer.pullback(
    value: \AppState.playerState,
    event: /AppEvent.player
  ),
  RecentPerformanceUI.reducer.pullback(
    value: \AppState.recentPerformance,
    event: /AppEvent.recentPerformance
  ),
  Reducer(reduce: MatchesUI.reducer)
    .pullback(value: \AppState.matchesState, event: /AppEvent.matches),
  HeroesGridUI.reducer
    .pullback(value: \AppState.heroes, event: /AppEvent.heroes)
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
      RecentPerformanceUI.Dependency(repository: $0.recentPerformance)
    }
  ),
  MatchesUI.feedbacks.pullback(
    value: \AppState.matchesState,
    event: /AppEvent.matches,
    dependency: {
      MatchesUI.Dependencies(useCase: $0.matchesUseCase)
    }
  ),
  HeroesGridUI.feedbacks
    .pullback(
      value: \AppState.heroes,
      event: /AppEvent.heroes,
      dependency: {
        HeroesGridUI.Dependencies(
          heroList: $0.heroesListUseCase,
          recentPerformance: $0.recentPerformance,
          abilities: $0.abilities
        )
      }
    )
)
