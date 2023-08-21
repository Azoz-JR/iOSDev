//
//  RootView.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI

struct RootView: View {
    
    // Access the RecipesViewModel from the environment
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    // State variable to control the presentation of the sign-in view
    @State private var showSignInView = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                // Display the TabBar when the sign-in view is not shown
                TabBar(showSignInView: $showSignInView)
                    .environmentObject(recipesViewModel)
            }
        }
        .onAppear {
            // Check if the user is authenticated on view appearance
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            
            // Set showSignInView based on the authentication status
            showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            // Present the AuthenticationView as a full-screen cover when showSignInView is true
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(RecipesViewModel())
    }
}
