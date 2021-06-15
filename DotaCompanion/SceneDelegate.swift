//
//  SceneDelegate.swift
//  DotaCompanion
//
//  Created by sergdort on 03/05/2021.
//

import SwiftUI
import UIKit
import DotaDomain

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

    // Create the SwiftUI view that provides the window contents.
    CurrentUser.currentUserId = 118113925
    let contentView = RootView()

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
