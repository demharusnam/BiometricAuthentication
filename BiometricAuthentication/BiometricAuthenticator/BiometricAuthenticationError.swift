//
//  BiometricAuthenticationError.swift
//  BiometricAuthentication
//
//  Created by Mansur Ahmed on 12/6/24.
//

import LocalAuthentication

enum BiometricAuthenticationError: Error {
  case unableToEvaluatePolicy(_ policy: LAPolicy)
  case authenticationFailed(any Error)
}
