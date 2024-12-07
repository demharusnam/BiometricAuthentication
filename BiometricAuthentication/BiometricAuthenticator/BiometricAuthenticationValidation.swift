//
//  BiometricAuthenticationValidation.swift
//  BiometricAuthentication
//
//  Created by Mansur Ahmed on 12/6/24.
//

protocol BiometricAuthenticationValidation: Actor {
  func deviceSupportsBiometricAuthentication() throws -> Bool
}
