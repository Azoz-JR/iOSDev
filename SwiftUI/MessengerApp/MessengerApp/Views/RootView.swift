//
//  RootView.swift
//  ChatApp
//
//  Created by Azoz Salah on 31/07/2023.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @State private var showSignInView = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack {
                    ContentView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear {            
            showSignInView = !streamViewModel.isSignedIn
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                LoginView(showSignInView: $showSignInView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(StreamViewModel())
    }
}
