//
//  BiometricAuthenticator.swift
//  BiometricAuthentication
//
//  Created by Mansur Ahmed on 12/6/24.
//

import LocalAuthentication
import OSLog

/// Provides an abstraction layer for biometric authentication.
final actor BiometricAuthenticator: BiometricAuthentication {
  
  // MARK: - Properties
  
  private var context = LAContext()
  private let policy: LAPolicy = .deviceOwnerAuthentication
  private let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: String(describing: BiometricAuthenticator.self)
  )
  
  // MARK: - BiometricAuthentication
  
  func authenticate() async -> Result<Void, BiometricAuthenticationError> {
    guard canPerformBiometricAuthentication() else {
      return .failure(.unableToEvaluatePolicy(policy))
    }
    
    logger.debug("Evaluating biometric authentication...")
    
    do {
      try await context.evaluatePolicy(policy, localizedReason: LocalizedString.authenticationReason)
      logger.debug("Biometric authentication evaluated successfully with policy \(self.policy)!")
      
      return .success(())
    } catch {
      logger.error("Failed to evaluate biometric authentication for policy \(self.policy) with error: \(error)")
      
      return .failure(.authenticationFailed(error))
    }
  }
  
  func deviceSupportsBiometricAuthentication() -> Bool {
     canPerformBiometricAuthentication()
  }
  
  var biometryType: LABiometryType {
    context.biometryType
  }
  
  // MARK: - Private Methods
  
  private func canPerformBiometricAuthentication() -> Bool {
    logger.debug("Testing if can evaluate biometric authentication with policy \(self.policy)...")
    
    // reset context on each authentication
    context.invalidate()
    context = LAContext()
    
    var error: NSError?
    
    defer {
      if let error {
        logger.error("Unable to test evaulation of \(self.policy) policy with error: \(error)")
      } else {
        logger.debug("Can perform biometric authentication with policy \(self.policy)!")
      }
    }
    
    return context.canEvaluatePolicy(policy, error: &error)
  }
}

// MARK: - LocalizedString

private extension BiometricAuthenticator {
  enum LocalizedString {
    static let authenticationReason = "Access your wallet"
  }
}
