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
  @State private var scale: CGFloat = 1
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      biometricAuthenticationImage
      title
      loginButton
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
      switch viewModel.loginState {
      case .loggedIn:
        viewModel.logout()
        
      case .loggedOut:
        Task { await viewModel.authenticate() }
      }
    } label: {
      loginButtonTitle
        .frame(maxWidth: titleTextWidth)
    }
    .buttonStyle(.borderedProminent)
    .tint(viewModel.loginState == .loggedIn ? .red : .blue)
    .clipped()
    .disabled(viewModel.loginStateIsUpdating)
    .onLongPressGesture(perform: {}, onPressingChanged: { pressing in
      withAnimation(.easeOut) {
        scale = pressing ? 0.9 : 1
      }
    })
    .scaleEffect(scale)
    .animation(.default, value: viewModel.loginStateIsUpdating)
  }
  
  private var loginButtonTitle: some View {
    Text(loginButtonTitleText)
      .fontDesign(.rounded)
      .font(.headline)
      .bold()
      .lineLimit(2)
      .allowsTightening(true)
      .minimumScaleFactor(0.1)
      .transition(.slide.combined(with: .opacity))
      .id(loginButtonTitleText)
  }
  
  private var loginButtonTitleText: String {
    viewModel.loginState == .loggedIn ? LocalizedString.logoutButtonTitleText : LocalizedString.loginButtonTitleText
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
      .scaleEffect(viewModel.loginStateIsUpdating ? 0.85 : 1, anchor: .bottom)
      .animation(viewModel.loginStateIsUpdating ? animation.repeatForever() : animation, value: viewModel.loginStateIsUpdating)
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
