//
//  AppDelegate.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
// 

import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication
                        .LaunchOptionsKey: Any]?) -> Bool {
                            configureApplicationAppearance()
                            
                            FirebaseApp.configure()
                            
                            return true
                        }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
    
    
    // MARK: - systemOrange
    private func configureApplicationAppearance() {
        let accentColor = UIColor(named: "NavbarBackgroundColor")
        let accentColor1 = UIColor(named: "ReversedBackgroundColorSet")
        
//        UINavigationBar.appearance().tintColor = accentColor ?? .systemOrange
        UITabBar.appearance().backgroundColor = accentColor 
        UITabBar.appearance().tintColor = accentColor1
    }
    
    
}
