//
//  TabBar.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI

struct TabBar: View {
    
    @EnvironmentObject var viewModel: RecipesViewModel
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            Group {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                CategoriesView()
                    .tabItem {
                        Label("Categories", systemImage: "square.fill.text.grid.1x2")
                    }
                
                NewView()
                    .tabItem {
                        Label("New", systemImage: "plus")
                    }
                
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
                
                SettingsView(showSignInView: $showSignInView)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
        .environmentObject(viewModel)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(showSignInView: .constant(false))
            .environmentObject(RecipesViewModel())
    }
}
