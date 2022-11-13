//
//  SceneDelegate.swift
//  DotaCompanion
//
//  Created by sergdort on 03/05/2021.
//

import SwiftUI
import UIKit
import DotaDomain
import CombineFeedback

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    CurrentUser.currentUserId = 86725175
    let contentView = RootView(
      store: Store(
        initial: AppState(),
        feedbacks: [appFeedbacks],
        reducer: appReducer,
        dependency: AppDependency()
      )
    )

    // Use a UIHostingController as window root view controller.
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      let viewController = UIHostingController(rootView: contentView)
      viewController.view.backgroundColor = Colors.backgroundFront.uiColor
      window.backgroundColor = Colors.backgroundFront.uiColor
      window.rootViewController = viewController
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}
