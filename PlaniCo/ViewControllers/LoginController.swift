//
//  LoginController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
  weak var delegate: LoginDelegate?

  private var loginView: LoginView { view as! LoginView }

  private var email: String { loginView.emailTextField.text! }
  private var password: String { loginView.passwordTextField.text! }

  // Hides tab bar when view controller is presented
  override var hidesBottomBarWhenPushed: Bool { get { true } set {} }

  // MARK: - View Controller Lifecycle Methods

  override func loadView() {
    view = LoginView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureDelegatesAndHandlers()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      let accentColor = UIColor(named: "AccentColor")
    navigationController?.setTitleColor(accentColor ?? .label)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
//    setts the color of authentication page after going back from email auth
    let accentColor = UIColor(named: "AccentColor")
    navigationController?.setTitleColor(accentColor ?? .systemRed)
  }

    
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    navigationController?.popViewController(animated: false)
  }

  // Dismisses keyboard when view is tapped
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }

  // MARK: - Firebase 🔥

  private func login(with email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
      guard error == nil else { return self.displayError(error) }
      self.delegate?.loginDidOccur()
    }
  }

  private func createUser(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      guard error == nil else { return self.displayError(error) }
      self.delegate?.loginDidOccur()
    }
  }

  // MARK: - Action Handlers

  @objc
  private func handleLogin() {
    login(with: email, password: password)
  }

  @objc
  private func handleCreateAccount() {
    createUser(email: email, password: password)
  }

  // MARK: - UI Configuration

    private func configureNavigationBar() {
        navigationItem.title = "Bine ați venit"
        let accentColor = UIColor(named: "AccentColor")
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .red]
        navigationItem.backBarButtonItem?.tintColor = .systemYellow
        navigationController?.navigationBar.prefersLargeTitles = true
    }


  private func configureDelegatesAndHandlers() {
    loginView.emailTextField.delegate = self
    loginView.passwordTextField.delegate = self
    loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
      loginView.orLabel
    loginView.createAccountButton.addTarget(self, action: #selector(handleCreateAccount), for: .touchUpInside )
  }
    
    
    
    
  override func viewWillTransition(to size: CGSize,
                                   with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    loginView.emailTopConstraint.constant = UIDevice.current.orientation.isLandscape ? 15 : 50
    loginView.passwordTopConstraint.constant = UIDevice.current.orientation.isLandscape ? 5 : 20
  }
}

// MARK: - UITextFieldDelegate

extension LoginController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if loginView.emailTextField.isFirstResponder, loginView.passwordTextField.text!.isEmpty {
      loginView.passwordTextField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return true
  }
}
