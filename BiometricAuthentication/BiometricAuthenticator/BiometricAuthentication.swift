//
//  BiometricAuthentication.swift
//  BiometricAuthentication
//
//  Created by Mansur Ahmed on 12/6/24.
//

import LocalAuthentication

protocol BiometricAuthentication: Actor, BiometricAuthenticationValidation {
  func authenticate() async -> Result<Void, BiometricAuthenticationError>
  var biometryType: LABiometryType { get }
}
