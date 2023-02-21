//
//  UserActions.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//



// Namespace for peformable actions on a Firebase User instance
enum UserAction: String {
  case signOut = "Ieșire"
  case requestVerifyEmail = "Solicitați verificarea e-mailului"
  case delete = "Ștergere"
  case updateEmail = "Email"
  case updatePhotoURL = "Adresa URL a fotografiei"
    case updateDisplayName = "Numele de afișare"
    case updatePassword = "Numar de telefon"
    case refreshUserInfo = "Reîmprospătează informațiile"
}
