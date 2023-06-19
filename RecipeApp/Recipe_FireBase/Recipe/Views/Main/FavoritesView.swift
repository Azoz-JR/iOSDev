//
//  FavoritesView.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI


struct FavoritesView: View {
    
    // Access the RecipesViewModel from the environment
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    // State variable to store the searched text
    @State private var searchedText = ""
    
    // Define the grid layout for recipe cards
    let columns = [GridItem(.adaptive(minimum: 160), spacing: 15)]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: 0x6495ED).ignoresSafeArea()
                
                if !recipesViewModel.userFavoriteRecipes.isEmpty {
                    VStack(alignment: .leading) {
                        // Display the count of filtered recipes
                        Text("\(filteredRecipes.count) \(filteredRecipes.count > 1 ? "recipes" : "recipe")")
                            .font(.headline)
                            .fontWeight(.medium)
                            .opacity(0.7)
                            .padding(.horizontal)
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 15) {
                                // Iterate over filtered recipes and display recipe cards
                                ForEach(filteredRecipes) { recipe in
                                    NavigationLink {
                                        RecipeViewViewBuilder(recipeId: recipe.recipeId)
                                    } label: {
                                        RecipeCardViewBuilder(recipeId: recipe.recipeId)
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                        
                        // Enable searching within the ScrollView
                        .searchable(text: $searchedText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search for a recipe")
                    }
                } else {
                    Text("You haven't saved any recipe to your favorites yet.")
                        .foregroundColor(Color(hex: 0x152238))
                        .font(.title3)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Favorites")
            
            // Fetch user's favorite recipes when the view appears
            .onAppear {
                recipesViewModel.getFavorites()
            }
        }
    }
    
    // Filter the favorite recipes based on the searched text
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

