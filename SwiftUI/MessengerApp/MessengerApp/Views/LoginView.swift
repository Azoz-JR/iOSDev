//
//  LoginView.swift
//  ChatApp
//
//  Created by Azoz Salah on 30/07/2023.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @Binding var showSignInView: Bool
    
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(stops: [
                    .init(color: Color(hex: 0x0496ff), location: 0),
                    .init(color: .white, location: 0.05)
                ], center: .topLeading, startRadius: 200, endRadius: 205).ignoresSafeArea()
                
                
                VStack(spacing: 20) {
                    Text ("Welcome!")
                        .font(.title.bold())
                        .offset(y: -100)
                        
                    
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .frame(width: 300, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.primary, lineWidth: 2)
                                
                        }
                    
//                    TextField("Password", text: $password)
//                        .padding()
//                        .frame(width: 300, alignment: .leading)
//                        .background {
//                            RoundedRectangle(cornerRadius: 30)
//                                .stroke(.primary, lineWidth: 2)
//                        }
//                    
//                    Button {
//                        
//                    } label: {
//                        Text("Forget password?")
//                            .foregroundColor(Color(hex: 0x0496ff))
//                    }
//                    .offset(x: 70, y: -10)
                    
                    
                    Button {
                        DispatchQueue.main.async {
                            streamViewModel.signIn(username: username) { success in
                                if success {
                                    showSignInView = false
                                }
                            }
                        }
                    } label: {
                        Text("LOGIN")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(width: 180)
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color(hex: 0x0496ff))
                                    .shadow(radius: 15)
                            }
                    }
                    .disabled(username.isEmpty)
                    .offset(y: 30)
                    
                    HStack(spacing: 5) {
                        Text("Don't have an account?")
                        Button {
                            
                        } label: {
                            Text("Create Account")
                                .foregroundColor(Color(hex: 0x0496ff))
                        }
                    }
                    .offset(y: 60)

                }
            }
            .alert("ERROR LOGGING IN...", isPresented: $streamViewModel.error) {
                Button("OK") {}
            } message: {
                Text(streamViewModel.errorMsg)
            }
            .environmentObject(streamViewModel)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showSignInView: .constant(true))
            .environmentObject(StreamViewModel())
    }
}
