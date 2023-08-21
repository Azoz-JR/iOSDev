//
//  SignUpEmailView.swift
//  FireBaseBootCamp
//
//  Created by Azoz Salah on 20/03/2023.
//

import SwiftUI


struct SignUpEmailView: View {
    
    @StateObject private var viewModel = SignUpEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            Image("signUpBackground")
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
                            try await viewModel.signUp()
                            showSignInView = false
                        } catch {
                            print("ERROR SIGNING UP: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        .navigationTitle("Sign Up With Email")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct SignUpEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpEmailView(showSignInView: .constant(true))
        }
    }
}
