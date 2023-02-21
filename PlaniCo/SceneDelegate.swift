//
//  SceneDelegate.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  lazy var authNavController: UINavigationController = {
    let navController = UINavigationController(rootViewController: AuthViewController())
    navController.view.backgroundColor = .systemBackground
    return navController
  }()
    
    lazy var homeNavController: UINavigationController = {
      let navController = UINavigationController(rootViewController: HomeViewController())
      navController.view.backgroundColor = .systemBackground
      return navController
    }()

  lazy var userNavController: UINavigationController = {
    let navController = UINavigationController(rootViewController: UserViewController())
    navController.view.backgroundColor = .systemBackground
    return navController
  }()

  lazy var tabBarController: UITabBarController = {
    let tabBarController = UITabBarController()
    tabBarController.delegate = tabBarController
    tabBarController.view.backgroundColor = .systemBackground
    return tabBarController
  }()

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    configureControllers()

    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = tabBarController
    window?.makeKeyAndVisible()
  }

  // MARK: - Private Helpers

  private func configureControllers() {
    authNavController.configureTabBar(
      title: "Autentificare",
      systemImageName: "person.crop.circle.fill.badge.plus"
    )
      homeNavController.configureTabBar(
        title: "Acasă",
        systemImageName: "house.fill"
      )
    userNavController.configureTabBar(title: "Utilizator curent", systemImageName: "person.fill")
    tabBarController.viewControllers = [authNavController, homeNavController, userNavController]
  }
}
