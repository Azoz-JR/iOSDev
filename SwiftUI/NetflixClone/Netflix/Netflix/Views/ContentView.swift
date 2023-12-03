//
//  ContentView.swift
//  Netflix
//
//  Created by Azoz Salah on 01/02/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: NetflixViewModel
    
    var body: some View {
        TabView {
            Group {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                ComingSoonView()
                    .tabItem {
                        Label("Coming Soon", systemImage: "play.rectangle.on.rectangle")
                    }
                
                DownloadView()
                    .tabItem {
                        Label("Downloads", systemImage: "arrow.down.to.line")
                    }
            }
            .environmentObject(viewModel)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
            .environmentObject(NetflixViewModel())
    }
}
