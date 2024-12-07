//
//  LAPolicy+CustomStringConvertible.swift
//  BiometricAuthentication
//
//  Created by Mansur Ahmed on 12/6/24.
//

import LocalAuthentication

extension LAPolicy: @retroactive CustomStringConvertible {
  public var description: String {
    switch self {
    case .deviceOwnerAuthentication:
      return "deviceOwnerAuthentication"
      
    case .deviceOwnerAuthenticationWithBiometrics:
      return "deviceOwnerAuthenticationWithBiometrics"
      
    case .deviceOwnerAuthenticationWithCompanion:
      return  "deviceOwnerAuthenticationWithCompanion"
      
    case .deviceOwnerAuthenticationWithBiometricsOrCompanion:
      return  "deviceOwnerAuthenticationWithBiometricsOrCompanion"
      
    @unknown default:
      return "unknown"
    }
  }
}
