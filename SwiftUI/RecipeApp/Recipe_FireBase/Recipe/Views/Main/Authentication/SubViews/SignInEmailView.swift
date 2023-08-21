//
//  SignInEmailView.swift
//  FireBaseBootCamp
//
//  Created by Azoz Salah on 19/03/2023.
//

import SwiftUI


struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    
    @State private var showSettingsView = false
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            Image("signInBackground")
                .resizable()
                .ignoresSafeArea()
            VStack {
                TextField("Email...", text: $viewModel.email)
                    .padding()
                    .background(.gray.opacity(0.7))
                    .cornerRadius(10)
                
                SecureField("Password...", text: $viewModel.password)
                    .padding()
                    .background(.gray.opacity(0.7))
                    .cornerRadius(10)
                
                Button {
                    Task {
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                        } catch {
                            print("ERROR SIGNING IN: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(.blue)
                        .cornerRadius(10)
                }
                
                NavigationLink {
                    SignUpEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Create account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(.green)
                        .cornerRadius(10)
                }
            }
            .padding()
        .navigationTitle("Sign In With Email")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(true))
        }
    }
}
