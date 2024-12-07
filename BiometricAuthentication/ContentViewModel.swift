//
//  ContentViewModel.swift
//  BiometricAuthentication
//
//  Created by Mansur Ahmed on 12/6/24.
//

import LocalAuthentication
import Observation
import UIKit

enum LoginState: Equatable {
  case loggedIn
  case loggedOut
}

@Observable
final class ContentViewModel {
  private(set) var loginState: LoginState = .loggedOut
  private(set) var loginStateIsUpdating: Bool = false
  var biometryType: LABiometryType = .none
  
  private let biometricAuthenticator: BiometricAuthentication = BiometricAuthenticator()
  private let notificationHapticFeedbackGenerator = UINotificationFeedbackGenerator()
  private let selectionhapticFeedbackGenerator = UISelectionFeedbackGenerator()
  
  init() {
    notificationHapticFeedbackGenerator.prepare()
    selectionhapticFeedbackGenerator.prepare()
    
    Task { biometryType = await biometricAuthenticator.biometryType }
  }
  
  func authenticate() async {
    loginStateIsUpdating = true
    
    defer {
      loginStateIsUpdating = false
    }
    
    await selectionhapticFeedbackGenerator.selectionChanged()
    switch await biometricAuthenticator.authenticate() {
    case .success:
      loginState = .loggedIn
      
    case .failure:
      loginState = .loggedOut
    }
  }
  
  func logout() {    
    notificationHapticFeedbackGenerator.notificationOccurred(.success)
    loginState = .loggedOut
  }
}
