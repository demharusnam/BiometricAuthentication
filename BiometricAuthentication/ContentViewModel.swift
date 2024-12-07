//
//  ContentViewModel.swift
//  BiometricAuthentication
//
//  Created by Mansur Ahmed on 12/6/24.
//

import LocalAuthentication
import Observation
import UIKit

@Observable
final class ContentViewModel {
  private(set) var loginState: LoginState = .loggedOut
  private(set) var biometryType: LABiometryType = .none
  
  @ObservationIgnored private let biometricAuthenticator: BiometricAuthentication = BiometricAuthenticator()
  
  // We use haptic feedback generators direectly instead of SwiftUI's sensoryFeedback API due to biometric
  // authentication cancelling any haptics occurring around the same time as the biometric authentication.
  // Likely because biometrics (FaceID at least) uses haptics to indidcate authentication result.
  @ObservationIgnored private let notificationHapticFeedbackGenerator = UINotificationFeedbackGenerator()
  @ObservationIgnored private let selectionhapticFeedbackGenerator = UISelectionFeedbackGenerator()
  
  init() {
    notificationHapticFeedbackGenerator.prepare()
    selectionhapticFeedbackGenerator.prepare()
    
    Task { biometryType = await biometricAuthenticator.biometryType }
  }
  
  func authenticate() async {
    guard loginState != .loggingIn else { return }
    
    loginState = .loggingIn
    
    await selectionhapticFeedbackGenerator.selectionChanged()
    
    let authenticationResult = await biometricAuthenticator.authenticate()
    
    // If you want to spam biometrics, uncomment the line below
    // to add an artifical 1.75 sec delay to let the biometric
    // animations finish. Otherwise we risk undefined behaviour.
    // try? await Task.sleep(nanoseconds: NSEC_PER_SEC * 7 / 4)
    
    guard loginState == .loggingIn else { return }
    
    switch authenticationResult {
    case .success:
      loginState = .loggedIn
      
    case .failure:
      loginState = .loggedOut
    }
  }
  
  func logout() {
    guard loginState != .loggedOut else { return }
    
    notificationHapticFeedbackGenerator.notificationOccurred(.success)
    loginState = .loggedOut
  }
}
