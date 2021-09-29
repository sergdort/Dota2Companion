import SwiftUI
import CombineFeedback

public struct RootView: View {
  let store: Store<AppState, AppEvent>

  init(store: Store<AppState, AppEvent>) {
    self.store = store
    UITabBar.appearance().barTintColor = Colors.backgroundFront.uiColor
    UINavigationBar.appearance().barTintColor = Colors.backgroundFront.uiColor
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Colors.textMain.uiColor]
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: Colors.textMain.uiColor]
  }

  public var body: some View {
    TabView {
      NavigationView {
        HomeView(store: store)
      }
      .tabItem {
        Label("Home", systemImage: "house")
      }
      NavigationView {
        HeroesGridUI.RootView(store: store.scoped(to: \.heroes, event: AppEvent.heroes))
      }
      .tabItem {
        Label("Heroes", systemImage: "ant")
      }
    }
  }
}
