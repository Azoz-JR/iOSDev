//
//  RecipeCardVIewBuilder.swift
//  Recipe
//
//  Created by Azoz Salah on 04/06/2023.
//

import SwiftUI

struct RecipeCardViewBuilder: View {
    
    let recipeId: String
    
    @State private var recipe: Recipe? = nil
    
    var body: some View {
        ZStack {
            if let recipe {
                // Display the RecipeCard view with the retrieved recipe
                RecipeCard(recipe: recipe)
            }
        }
        .task {
            // Retrieve the recipe asynchronously and assign it to the recipe state variable
            self.recipe = try? await RecipeManager.shared.getRecipe(recipeId: recipeId)
        }
    }
}


struct RecipeCardViewBuilder_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCardViewBuilder(recipeId: "6624D8E5-C2B7-41FD-9F52-F6FE633E1A85")
            .environmentObject(RecipesViewModel())
    }
}
