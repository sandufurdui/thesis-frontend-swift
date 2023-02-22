//
//  AuthProvider.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//



import UIKit

/// Firebase Auth supported identity providers and other methods of authentication
enum AuthProvider: String {
  case google = "google.com"
  case emailPassword = "password"

  /// More intuitively named getter for `rawValue`.
  var id: String { rawValue }

  /// The UI friendly name of the `AuthProvider`. Used for display.
  var name: String {
    switch self {
    case .google:
      return "Google"
    case .emailPassword:
      return "Email & Password Login"
    }
  }

  /// Failable initializer to create an `AuthProvider` from it's corresponding `name` value.
  /// - Parameter rawValue: String value representing `AuthProvider`'s name or type.
  init?(rawValue: String) {
    switch rawValue {
    case "Google":
      self = .google
  case "Email & Password Login":
      self = .emailPassword
    default: return nil
    }
  }
}

// MARK: DataSourceProvidable


//static var providerSection: Section {
//  let providers = self.providers.map { Item(title: $0.name) }
//  let header = "Metode de autentificare"
//  return Section(headerDescription: header, items: providers)
//}
//
//static var emailPasswordSection: Section {
//  let image = UIImage(named: "firebaseIcon")
//  let item = Item(title: emailPassword.name, hasNestedContent: true, image: image)
//  let footer = "Alegeți o metodă de autentificare"
//  return Section(footerDescription: footer, items: [item])
//}


extension AuthProvider: DataSourceProvidable {
  private static var providers: [AuthProvider] {
    [.google]
  }

    static var authenticationSection: Section {
        let providers = self.providers.map { Item(title: $0.name) }
        let image = UIImage(named: "firebaseIcon")
        let emailPasswordItem = Item(title: emailPassword.name, hasNestedContent: true, image: image)
        let header = "Metode de autentificare"
        let footer = "Alegeți o metodă de autentificare"
        return Section(headerDescription: header, footerDescription: footer, items: providers + [emailPasswordItem] )
    }

  static var sections: [Section] {
    [authenticationSection]
  }

  var sections: [Section] { AuthProvider.sections }
}
