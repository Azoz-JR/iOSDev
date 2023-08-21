//
//  RecipeList.swift
//  Recipe
//
//  Created by Azoz Salah on 29/05/2023.
//

import SwiftUI

struct RecipeList: View {
    
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    @State private var searchedText = ""
    
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 15),
        GridItem(.adaptive(minimum: 160), spacing: 15)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            // Display the count of filtered recipes
            Text("\(filteredRecipes.count) \(filteredRecipes.count > 1 ? "recipes" : "recipe")")
                .font(.headline)
                .fontWeight(.medium)
                .opacity(0.7)
                .padding(.horizontal)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(filteredRecipes) { recipe in
                        NavigationLink {
                            // Navigate to the recipe details view
                            RecipeView(recipe: recipe)
                        } label: {
                            // Display a card with recipe information
                            RecipeCard(recipe: recipe)
                        }
                        .task {
                            // Load more recipes when the last recipe is visible
                            if recipe == recipesViewModel.myRecipes.last {
                                recipesViewModel.getRecipes()
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .searchable(text: $searchedText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search for a recipe")
        }
    }
    
    var filteredRecipes: [Recipe] {
        // Filter the recipes based on the searched text
        if searchedText.isEmpty {
            return recipesViewModel.myRecipes
        } else {
            return recipesViewModel.myRecipes.filter { $0.name.localizedCaseInsensitiveContains(searchedText) }
        }
    }
}


struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeList()
                .environmentObject(RecipesViewModel())
        }
    }
}
