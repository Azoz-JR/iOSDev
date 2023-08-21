//
//  SettingsView.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI


struct ErrorAlert: Identifiable {
    var id: String { name }
    let name: String
}


struct SettingsView: View {
    
    // Create a state object for the view model
    @StateObject private var viewModel = SettingsViewModel()
    
    // Binding for showing the sign-in view
    @Binding var showSignInView: Bool
    
    // State variables for managing alerts and user input
    @State private var showingEmailAlert = false
    @State private var showingPasswordAlert = false
    @State private var newEmail = ""
    @State private var newPassword = ""
    @State private var errorAlert: ErrorAlert?
    @State private var showingSignInMethods = false
    @State private var showingEmailAndPasswordAlert = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                // Display the user's email or "Anonymous" if not logged in
                if !viewModel.authProviders.isEmpty {
                    Text("Email: \(viewModel.currentUserEmail)")
                } else {
                    Text("Email: Anonymous")
                }
                
                Button("Log out") {
                    Task {
                        do {
                            try viewModel.signOut()
                            showSignInView = true
                        } catch {
                            print("ERROR SIGNING OUT \(error.localizedDescription)")
                        }
                    }
                }
                
                // Button for deleting the user's account
                Button("Delete Account", role: .destructive) {
                    showingDeleteAlert = true
                }
                
                // Section for linking account if user is anonymous
                if viewModel.currentUser?.isAnonymous ?? false {
                    linkingSection
                }
                
                // Section for email-related functions if email is linked
                if viewModel.authProviders.contains(.email) {
                    emailSection
                }
            }
            
            // Update the view model and fetch auth providers when the view appears
            .onAppear {
                viewModel.getCurrentUser()
                viewModel.loadAuthProviders()
            }
            
            // Show an email alert for updating the email
            .alert("Enter your new email", isPresented: $showingEmailAlert) {
                TextField("New Email...", text: $newEmail)
                Button("Submit") {
                    guard !newEmail.trimmingCharacters(in: .whitespaces).isEmpty else {
                        errorAlert = ErrorAlert(name: "Email must contain characters")
                        return
                    }
                    Task {
                        do {
                            try await viewModel.updateEmail(email: newEmail)
                            newEmail = ""
                            print("Email Updated!")
                            viewModel.getCurrentUser()
                        } catch {
                            errorAlert = ErrorAlert(name: "ERROR UPDATING EMAIL: \(error.localizedDescription)")
                            newEmail = ""
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
            
            // Show a password alert for updating the password
            .alert("Enter your new password", isPresented: $showingPasswordAlert) {
                TextField("New Password...", text: $newPassword)
                Button("Submit") {
                    guard !newPassword.trimmingCharacters(in: .whitespaces).isEmpty else {
                        errorAlert = ErrorAlert(name: "Password must contain characters")
                        return
                    }
                    Task {
                        do {
                            try await viewModel.updatePassword(password: newPassword)
                            newPassword = ""
                            print("Password Updated!")
                        } catch {
                            errorAlert = ErrorAlert(name: "ERROR UPDATING Password: \(error.localizedDescription)")
                            newPassword = ""
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
            
            // Show an alert for errors
            .alert(item: $errorAlert) { message in
                Alert(title: Text("Error"), message: Text(message.name), dismissButton: .cancel())
            }
            
            // Show an alert for linking email and password
            .alert("Enter your email and Password", isPresented: $showingEmailAndPasswordAlert) {
                TextField("Email...", text: $viewModel.email)
                SecureField("Password", text: $viewModel.password)
                Button("Submit") {
                    guard
                        !viewModel.email.trimmingCharacters(in: .whitespaces).isEmpty,
                        !viewModel.password.trimmingCharacters(in: .whitespaces).isEmpty else {
                        errorAlert = ErrorAlert(name: "Email and Password must contain characters")
                        return
                    }
                    Task {
                        do {
                            try await viewModel.connectAnonymousToEmail()
                            viewModel.email = ""
                            viewModel.password = ""
                            viewModel.getCurrentUser()
                        } catch {
                            errorAlert = ErrorAlert(name: "ERROR CONNECTING TO EMAIL: \(error.localizedDescription)")
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
            
            // Show an alert for deleting the account
            .alert("Are you sure you want to delete your account", isPresented: $showingDeleteAlert) {
                Button("Yes", role: .destructive) {
                    Task {
                        do {
                            try await viewModel.deleteUser()
                            showSignInView = true
                        } catch {
                            errorAlert = ErrorAlert(name: "ERROR DELETING YOUR ACCOUNT: \(error.localizedDescription)")
                            print("ERROR DELETING YOUR ACCOUNT: \(error.localizedDescription)")
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Once you delete your account, you will not be able to undo this action")
            }
            
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSignInView: .constant(false))
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section {
            // Button for updating the email
            Button("Update Email") {
                showingEmailAlert.toggle()
            }
            
            // Button for updating the password
            Button("Update Password") {
                showingPasswordAlert.toggle()
            }
            
            // Button for resetting the password
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPassword(email: viewModel.currentUserEmail)
                        print("PASSWORD RESET!")
                    } catch {
                        print("ERROR RESETTING PASSWORD \(error.localizedDescription)")
                    }
                }
            }
        } header: {
            Text("Email Functions")
        }
    }
}

extension SettingsView {
    private var linkingSection: some View {
        Section {
            // Button for linking with Google
            Button("Google") {
                Task {
                    do {
                        try await viewModel.connectAnonymousToGoogle()
                    } catch {
                        print("ERROR SIGNING IN WITH GOOGLE: \(error.localizedDescription)")
                    }
                }
            }
            
            // Button for linking with email
            Button("Email") {
                showingEmailAndPasswordAlert = true
            }
            
            // Button for linking with Apple
            Button("Apple") {
                Task {
                    do {
                        try await viewModel.connectAnonymousToApple()
                    } catch {
                        print("ERROR SIGNING IN WITH APPLE: \(error.localizedDescription)")
                    }
                }
            }
        } header: {
            Text("Connecting options")
        }
    }
}

