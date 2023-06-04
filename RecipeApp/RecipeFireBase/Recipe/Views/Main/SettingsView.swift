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
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    @State private var showingEmailAlert = false
    @State private var showingPasswordAlert = false
    @State private var newEmail = ""
    @State private var newPassword = ""
    @State private var errorAlert: ErrorAlert?
    @State private var showingSignInMethods = false
    @State private var showingEmailAndPasswordAlert = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        List {
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
            
            Button("Delete Account", role: .destructive) {
                showingDeleteAlert = true
            }
            
            if viewModel.currentUser?.isAnonymous ?? false {
                linkingSection
            }
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
        }
        .onChange(of: showSignInView) { newValue in
            if !newValue {
                viewModel.getCurrentUser()
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            viewModel.getCurrentUser()
            viewModel.loadAuthProviders()
        }
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
        .alert(item: $errorAlert) { message in
            Alert(title: Text("Error"), message: Text(message.name), dismissButton: .cancel())
        }
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
            Button("Update Email") {
                showingEmailAlert.toggle()
            }
            
            Button("Update Password") {
                showingPasswordAlert.toggle()
            }
                        
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
            Button("Google") {
                Task {
                    do {
                        try await viewModel.connectAnonymousToGoogle()
                    } catch {
                        print("ERROR SIGNING IN WITH GOOGLE: \(error.localizedDescription)")
                    }
                }
            }
            
            Button("Email") {
                showingEmailAndPasswordAlert = true
            }
            
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
