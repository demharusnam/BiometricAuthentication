//
//  ContentView.swift
//  BiometricAuthentication
//
//  Created by Mansur Ahmed on 12/6/24.
//

import SwiftUI

struct ContentView: View {
  @State private var viewModel = ContentViewModel()
  @State private var titleTextWidth: CGFloat?
  @State private var loginButtonScale: CGFloat = 1
  @State private var logoutButtonScale: CGFloat = 1
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      biometricAuthenticationImage
      title
      
      ZStack {
        if viewModel.loginState == .loggedOut || viewModel.loginState == .loggingIn {
          loginButton
            .transition(.blurReplace)
            .id(LocalizedString.loginButtonTitleText)
        } else if viewModel.loginState == .loggedIn {
          logoutButton
            .transition(.blurReplace)
            .id(LocalizedString.logoutButtonTitleText)
        }
      }
      .animation(.bouncy, value: viewModel.loginState)
    }
  }
  
  private var title: some View {
    Text(LocalizedString.viewTitle)
      .fontDesign(.rounded)
      .font(.largeTitle)
      .bold()
      .background(GeometryReader { proxy in
        Color.clear
          .onAppear {
            titleTextWidth = proxy.size.width
          }
      })
  }
  
  private var loginButton: some View {
    Button {
      Task { await viewModel.authenticate() }
    } label: {
      buttonTitle(for: .loggedOut)
        .frame(maxWidth: titleTextWidth, maxHeight: 44)
    }
    .buttonStyle(.borderedProminent)
    .tint(.blue)
    .clipped()
    .onLongPressGesture(perform: {}, onPressingChanged: { pressing in
      withAnimation(.easeOut) {
        loginButtonScale = pressing ? 0.9 : 1
      }
    })
    .scaleEffect(loginButtonScale)
    .onChange(of: viewModel.loginState) { _, newValue in
      withAnimation(.bouncy) {
        switch newValue {
        case .loggedIn:
          loginButtonScale = 0.8
          
        case .loggedOut:
          loginButtonScale = 1
          
        case .loggingIn:
          break
        }
      }
    }
    .animation(.default, value: viewModel.loginState)
    .disabled(viewModel.loginState.isLoginState)
  }
  
  private var logoutButton: some View {
    Button {
        viewModel.logout()
    } label: {
      buttonTitle(for: .loggedIn)
        .frame(maxWidth: titleTextWidth, maxHeight: 44)
    }
    .buttonStyle(.borderedProminent)
    .tint(Color.red)
    .clipped()
    .onLongPressGesture(perform: {}, onPressingChanged: { pressing in
      withAnimation(.easeOut) {
        logoutButtonScale = pressing ? 0.9 : 1
      }
    })
    .scaleEffect(logoutButtonScale)
    .onChange(of: viewModel.loginState) { _, newValue in
      withAnimation(.bouncy) {
        switch newValue {
        case .loggedIn:
          logoutButtonScale = 1
          
        case .loggedOut:
          logoutButtonScale = 0.8
          
        case .loggingIn:
          break
        }
      }
    }
    .animation(.default, value: viewModel.loginState)
    .disabled(viewModel.loginState == .loggingIn || viewModel.loginState == .loggedOut)
  }
  
  private func buttonTitle(for loginState: LoginState) -> some View {
    let title = loginState == .loggedIn ? LocalizedString.logoutButtonTitleText : LocalizedString.loginButtonTitleText
    
    return Text(title)
      .fontDesign(.rounded)
      .font(.headline)
      .bold()
  }
  
  private var biometricAuthenticationImage: some View {
    let imageTint: Color
    let imageName: String
    
    switch viewModel.biometryType {
    case .faceID:
      imageName = "faceid"
      imageTint = .blue
      
    case .touchID:
      imageName = "touchid"
      imageTint = .red
      
    case .opticID:
      imageName = "opticid"
      imageTint = .gray
      
    case .none:
      imageName = "lock"
      imageTint = .gray
      
    @unknown default:
      imageName = "lock"
      imageTint = .gray
    }
    
    let animation = Animation.bouncy(duration: 0.35)
    
    return Image(systemName: imageName)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 50)
      .foregroundStyle(imageTint)
      .scaleEffect(viewModel.loginState == .loggingIn ? 0.85 : 1, anchor: .bottom)
      .animation(viewModel.loginState == .loggingIn ? animation.repeatForever() : animation, value: viewModel.loginState)
  }
}

private extension ContentView {
  enum LocalizedString {
    static let loginButtonTitleText = "Login"
    static let logoutButtonTitleText = "Logout"
    static let viewTitle = "Biometric\nAuthentication"
  }
}

#Preview {
  ContentView()
}
