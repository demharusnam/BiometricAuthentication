//
//  LoginState.swift
//  BiometricAuthentication
//
//  Created by Mansur Ahmed on 12/7/24.
//

enum LoginState: Equatable {
  case loggingIn
  case loggedIn
  case loggedOut
  
  // Indicates whether the login state is `loggedIn` or `loggingIn`
  var isLoginState: Bool {
    switch self {
    case .loggingIn, .loggedIn:
      return true
      
    case .loggedOut:
      return false
    }
  }
}
