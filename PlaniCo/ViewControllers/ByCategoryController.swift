//
//  sdgsdgds.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 31.03.2023.
//

//
//  ByCategoryController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 31.03.2023.
//

import UIKit
import FirebaseAuth
//import Charts
//import SwiftUI
//import Charts

class ByCategoryController: UIViewController {
    
    let userID = Auth.auth().currentUser?.uid


        override func viewDidLoad() {
            super.viewDidLoad()
            configureNavigationBar()
        }
        
        
  

    @objc private func refreshButtonTapped() {
        print("refreshData()")
    }
    
    @objc private func settingsButtonTapped() {
        let profileController = UserViewController() // Create an instance of the profile controller
        profileController.modalPresentationStyle = .pageSheet // Set the presentation style of the profile controller
        present(profileController, animated: true, completion: nil) // Present the profile controller
    }
    
    // MARK: configureNavigationBar()
    private func configureNavigationBar() {
        navigationItem.title = "By Category"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        let accentColor = UIColor(named: "AccentColor")
        navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .systemRed]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: accentColor ?? .systemRed]
        
        // Create and configure the settings button
        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and configure the refresh button
        let refreshButton = UIButton(type: .system)
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the buttons to the navigation bar
        navigationBar.addSubview(settingsButton)
        navigationBar.addSubview(refreshButton)
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 30),
            settingsButton.heightAnchor.constraint(equalToConstant: 30),
            settingsButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -16),
            settingsButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: 30),
            refreshButton.heightAnchor.constraint(equalToConstant: 30),
            refreshButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -16),
            refreshButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])
    }
}
