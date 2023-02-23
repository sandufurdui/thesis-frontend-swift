//
//  AuthViewController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
//import CryptoKit


class AuthViewController: UIViewController, DataSourceProviderDelegate {
    var dataSourceProvider: DataSourceProvider<AuthProvider>!
    
    override func loadView() {
        view = UITableView(frame: .zero, style: .insetGrouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDataSourceProvider()
    }
    
    // MARK: - DataSourceProviderDelegate
    
    func didSelectRowAt(_ indexPath: IndexPath, on tableView: UITableView) {
        let item = dataSourceProvider.item(at: indexPath)
        
        let providerName = item.isEditable ? item.detailTitle! : item.title!
        
        guard let provider = AuthProvider(rawValue: providerName) else {
            // The row tapped has no affiliated action.
            return
        }
        
        switch provider {
        case .google:
            performGoogleSignInFlow()
            
        case .emailPassword:
            performDemoEmailPasswordLoginFlow()
        }
    }
    
    // MARK: - Firebase 🔥
    
    private func performGoogleSignInFlow() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        // TODO: Move configuration to Info.plist
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else { return displayError(error) }
            
            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                let error = NSError(
                    domain: "GIDSignInError",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unexpected sign in result: required authentication data is missing.",
                    ]
                )
                return displayError(error)
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else { return self.displayError(error) }
                
                // At this point, our user is signed in
                // so we advance to the User View Controller
                self.transitionToUserViewController()
            }
        }
    }
    
    private func performDemoEmailPasswordLoginFlow() {
        let loginController = LoginController()
        loginController.delegate = self
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    
    private func signin(with credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { result, error in
            guard error == nil else { return self.displayError(error) }
            self.transitionToUserViewController()
        }
    }
    
    // MARK: - Private Helpers
    
    private func configureDataSourceProvider() {
        let tableView = view as! UITableView
        dataSourceProvider = DataSourceProvider(dataSource: AuthProvider.sections, tableView: tableView)
        dataSourceProvider.delegate = self
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Autentificare"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        
        let accentColor = UIColor(named: "AccentColor")
        navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .systemRed]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: accentColor ?? .systemRed]
    }
    
    
    
    private func transitionToUserViewController() {
        // UserViewController is at index 1 in the tabBarController.viewControllers array
        tabBarController?.transitionToViewController(atIndex: 1)
    }
}

// MARK: - LoginDelegate

extension AuthViewController: LoginDelegate {
    public func loginDidOccur() {
        transitionToUserViewController()
        
    }
}
