//
//  RecipesViewModel.swift
//  Recipe
//
//  Created by Azoz Salah on 28/05/2023.
//

import Foundation
import Firebase

@MainActor
final class RecipesViewModel: ObservableObject {
    
    @Published private(set) var myRecipes: [Recipe] = []
    @Published private(set) var userFavoriteRecipes: [UserFavoriteRecipe] = []
    @Published var selectedCategory: Category? = nil
    @Published var newRecipe: Recipe? = nil
    
    private var lastDocument: DocumentSnapshot? = nil
    
    func downloadRecipesAndUploadToFirebase() {
        // Retrieve the recipes to upload
        let recipes = Recipe.all

        do {
            // Upload each recipe to Firebase
            for recipe in recipes {
                try RecipeManager.shared.uploadRecipe(recipe: recipe)
            }
        } catch {
            print("ERROR UPLOADING RECIPES TO FIREBASE: \(error.localizedDescription)")
        }
    }
    
    func categorySelected(option: Category) {
        // Set the selected category and reset the recipe list
        self.selectedCategory = option
        self.myRecipes = []
        self.lastDocument = nil
        getRecipes()
    }
    
    func getRecipes() {
        Task {
            // Retrieve recipes asynchronously based on selected category and pagination
            let (newRecipes, lastDocument) = try await RecipeManager.shared.getAllRecipes(nameDescending: false, forCategory: selectedCategory?.categoryKey, count: 5, lastDocument: lastDocument)
            
            objectWillChange.send()
            // Append new recipes to the existing recipe list
            self.myRecipes.append(contentsOf: newRecipes)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
    
    func getFavorites() {
        Task {
            // Get the authenticated user's favorite recipes
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            
            self.userFavoriteRecipes = try await UserManager.shared.getAllUserFavoriteRecipes(userId: authDataResult.uid)
        }
    }
    
    func addUserFavoriteRecipe(recipeId: String, recipeName: String) {
        Task {
            // Add a recipe to the user's favorites
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.addUserFavoriteRecipe(userId: authDataResult.uid, recipeId: recipeId, recipeName: recipeName)
            getFavorites()
        }
    }
        
    func removeUserFavoriteRecipe(favoriteRecipeId: String) {
        Task {
            // Remove a recipe from the user's favorites
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.removeUserFavoriteRecipe(userId: authDataResult.uid, favoriteRecipeId: favoriteRecipeId)
            getFavorites()
        }
    }
    
    func contains(_ recipe: Recipe) -> Bool {
        // Check if a recipe is present in the user's favorites
        userFavoriteRecipes.contains { $0.recipeId == recipe.id.uuidString }
    }
    
}
