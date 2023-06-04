//
//  SettingsViewModel.swift
//  Recipe
//
//  Created by Azoz Salah on 02/06/2023.
//

import Foundation
import FirebaseAuth


@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var currentUserEmail: String = ""
    @Published var email = ""
    @Published var password = ""
    @Published var currentUser: User?
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteUser() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword(email: String) async throws {
        try await AuthenticationManager.shared.resetPassword(email: currentUserEmail)
    }
    
    func updateEmail(email: String) async throws {
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword(password: String) async throws {
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func getCurrentUser() {
        do {
            let currentUser = try AuthenticationManager.shared.getAuthenticatedUser()
            self.currentUser = currentUser
            
            guard let email = currentUser.email else { throw URLError(.fileDoesNotExist) }
            self.currentUserEmail = email
        } catch {
            print("ERROR GETTING CURRENT USER: \(error.localizedDescription)")
        }
    }
    
    func connectAnonymousToGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.connectAnonymousToGoogle(tokens: tokens)
    }
    
    func connectAnonymousToEmail() async throws {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("No Email or Password found.")
            return
        }
        
        try await AuthenticationManager.shared.connectAnonymousToEmail(email: email, password: password)
    }
    
    func connectAnonymousToApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenticationManager.shared.connectAnonymousToApple(tokens: tokens)
    }
}
