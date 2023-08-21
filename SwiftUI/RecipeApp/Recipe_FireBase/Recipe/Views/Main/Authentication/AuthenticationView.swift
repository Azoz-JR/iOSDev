//
//  AuthenticationView.swift
//  Recipe
//
//  Created by Azoz Salah on 01/06/2023.
//

import SwiftUI
import GoogleSignInSwift

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            Image("appBackground")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 20) {
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
                            showSignInView = false
                        } catch {
                            print("ERROR SIGNING IN WITH GOOGLE..\(error.localizedDescription)")
                        }
                    }
                }
                
                Button {
                    Task {
                        do {
                            try await viewModel.signInApple()
                            showSignInView = false
                        } catch {
                            print("ERROR SIGNING IN WITH APPLE..\(error.localizedDescription)")
                        }
                    }
                } label: {
                    SignInWithAppleButtonViewRepresentable(type: .signIn, style: .black)
                        .allowsHitTesting(false)
                }
                .frame(height: 55)
                
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    HStack {
                        Image(systemName: "envelope")
                        Text("Sign In with Email")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.red)
                    .cornerRadius(10)
                }
                
                Button {
                    Task {
                        do {
                            try await viewModel.signInAnonymously()
                            showSignInView = false
                        } catch {
                            print("ERROR SIGNING IN ANONYMOUSLY: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("Sign In Anonymously")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(.green)
                        .cornerRadius(10)
                }
                
            }
            .padding()
        .navigationTitle("Sign In")
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(showSignInView: .constant(true))
    }
}
