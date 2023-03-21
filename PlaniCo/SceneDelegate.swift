//
//  SceneDelegate.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//


import UIKit
import SwiftUI
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    lazy var authNavController: UINavigationController = {
        let navController = UINavigationController(rootViewController: AuthViewController())
        navController.view.backgroundColor = .systemBackground
        return navController
    }()
    
    lazy var historyViewController: UINavigationController = {
        let navController = UINavigationController(rootViewController: HistoryViewController())
        navController.view.backgroundColor = .systemBackground
        return navController
    }()
    
    lazy var addReceiptController: UINavigationController = {
        let navController = UINavigationController(rootViewController: AddReceiptController())
        navController.view.backgroundColor = .systemBackground
        return navController
    }() 
    lazy var summaryController: UINavigationController = {
        let navController = UINavigationController(rootViewController: SummaryController())
        navController.view.backgroundColor = .systemBackground
        return navController
    }()
    lazy var summaryController2: UINavigationController = {
        let navController = UINavigationController(rootViewController: SummaryController2())
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
        
        // Update navbar when user logs in or out
        Auth.auth().addStateDidChangeListener { auth, user in
            self.updateNavBar(for: user)
        }
    }
    
    // MARK: - Private Helpers
    
        private func configureControllers() {
            authNavController.configureTabBar(
                title: "Autentificare",
                systemImageName: "person.crop.circle.fill.badge.plus"
            )
            historyViewController.configureTabBar(
                title: "Transactions",
                systemImageName: "clock.fill"
            )
            addReceiptController.configureTabBar(
                title: "Scan",
                systemImageName: "plus.circle"
            )
            summaryController.configureTabBar(
                title: "Summary",
                systemImageName: "house.fill"
            )
            summaryController2.configureTabBar(
                title: "Summary 2",
                systemImageName: "house.fill"
            )
            userNavController.configureTabBar(title: "Utilizator curent", systemImageName: "person.fill")
//            tabBarController.viewControllers = [authNavController, homeNavController, userNavController]
        }
    
    private func updateNavBar(for user: User?) {
        if let _ = user {
            // User is logged in
            tabBarController.viewControllers = [
                summaryController,
                summaryController2,
                historyViewController,
                addReceiptController, userNavController]
        } else {
            // User is logged out
            tabBarController.viewControllers = [authNavController]
        }
    }
    
    
}
