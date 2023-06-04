//
//  FavoritesView.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI


struct FavoritesView: View {
    
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    @State private var searchedText = ""

    let columns = [GridItem(.adaptive(minimum: 160), spacing: 15)]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: 0x6495ED).ignoresSafeArea()
                if !recipesViewModel.userFavoriteRecipes.isEmpty {
                    VStack(alignment: .leading) {
                        Text("\(filteredRecipes.count) \(filteredRecipes.count > 1 ? "recipes" : "recipe")")
                            .font(.headline)
                            .fontWeight(.medium)
                            .opacity(0.7)
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(filteredRecipes) { recipe in
                                    NavigationLink {
                                        RecipeViewViewBuilder(recipeId: recipe.recipeId)
                                    } label: {
                                        RecipeCardViewBuilder(recipeId: recipe.recipeId)
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                            .padding(.top)
                        }
                        .searchable(text: $searchedText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search for a recipe")
                    }
                    .padding(.horizontal)
                } else {
                    Text("You haven't saved any recipe to your favorites yet.")
                        .foregroundColor(Color(hex: 0x152238))
                        .font(.title3)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                recipesViewModel.getFavorites()
            }
        }
    }
    
    var filteredRecipes: [UserFavoriteRecipe] {
        if searchedText.isEmpty {
            return recipesViewModel.userFavoriteRecipes
        } else {
            return recipesViewModel.userFavoriteRecipes.filter { $0.recipeName.localizedCaseInsensitiveContains(searchedText) }
        }
    }
    
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(RecipesViewModel())
    }
}

