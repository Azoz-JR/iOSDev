//
//  FavoritesView.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if !recipesViewModel.favorites.isEmpty {
                    RecipeList(recipes: recipesViewModel.favorites)
                } else {
                    Text("You haven't saved any recipe to your favorites yet.")
                        .padding(.horizontal)
                }
            }
                .navigationTitle("Favorites")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(RecipesViewModel())
    }
}
