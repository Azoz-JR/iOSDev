//
//  RecipeViewViewBuilder.swift
//  Recipe
//
//  Created by Azoz Salah on 04/06/2023.
//

import SwiftUI

struct RecipeViewViewBuilder: View {
    
    let recipeId: String
    
    @State private var recipe: Recipe? = nil
    
    var body: some View {
        ZStack {
            if let recipe {
                // Display the RecipeView with the retrieved recipe
                RecipeView(recipe: recipe)
            }
        }
        .task {
            // Retrieve the recipe asynchronously and assign it to the recipe state variable
            self.recipe = try? await RecipeManager.shared.getRecipe(recipeId: recipeId)
        }
    }
}

struct RecipeViewViewBuilder_Previews: PreviewProvider {
    static var previews: some View {
        RecipeViewViewBuilder(recipeId: "")
    }
}
