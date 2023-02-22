//
//  HomeViewController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import CryptoKit


class HomeViewController: UIViewController {
  var dataSourceProvider: DataSourceProvider<AuthProvider>!

  override func loadView() {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let label = UILabel()
    label.text = "fuck u"
    label.textAlignment = .center
    tableView.backgroundView = label
    view = tableView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
  }

  private func configureNavigationBar() {
    navigationItem.title = "Acasă"
    guard let navigationBar = navigationController?.navigationBar else { return }
    navigationBar.prefersLargeTitles = true
    let accentColor = UIColor(named: "AccentColor")
    navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
    navigationBar.largeTitleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
  }

  private func transitionToUserViewController() {
    tabBarController?.transitionToViewController(atIndex: 1)
  }
}

// MARK: - LoginDelegate

extension HomeViewController: LoginDelegate {
  public func loginDidOccur() {
    transitionToUserViewController()
  }
}


