//
//  LoginDelegate.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//

import Foundation

// Delegate for signaling that a successful login with Firebase Auth has occurred
protocol LoginDelegate: NSObject {
  func loginDidOccur()
}

