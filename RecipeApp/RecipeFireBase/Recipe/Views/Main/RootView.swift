//
//  RootView.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    @State private var showSignInView = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                    TabBar(showSignInView: $showSignInView)
                        .environmentObject(recipesViewModel)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            
            showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
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
