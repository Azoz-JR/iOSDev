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
    
    private var lastDocument: DocumentSnapshot? = nil
    
    func downloadRecipesAndUploadToFirebase() {
        let recipes = Recipe.all

        do {
            for recipe in recipes {
                try RecipeManager.shared.uploadRecipe(recipe: recipe)
            }
        } catch {
            print("ERROR UPLOADING RECIPES TO FIREBASE: \(error.localizedDescription)")
        }
    }
    
    func categorySelected(option: Category) {
        self.selectedCategory = option
        self.myRecipes = []
        self.lastDocument = nil
        getRecipes()
    }
    
    func getRecipes() {
        Task {
            let (newRecipes, lastDocument) = try await RecipeManager.shared.getAllRecipes(nameDescending: false, forCategory: selectedCategory?.categoryKey, count: 5, lastDocument: lastDocument)
            
            objectWillChange.send()
            self.myRecipes.append(contentsOf: newRecipes)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
    
    func getFavorites() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            
            self.userFavoriteRecipes = try await UserManager.shared.getAllUserFavoriteRecipes(userId: authDataResult.uid)
        }
    }
    
    func addUserFavoriteRecipe(recipeId: String, recipeName: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.addUserFavoriteRecipe(userId: authDataResult.uid, recipeId: recipeId, recipeName: recipeName)
            getFavorites()
        }
    }
        
    func removeUserFavoriteRecipe(favoriteRecipeId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.removeUserFavoriteRecipe(userId: authDataResult.uid, favoriteRecipeId: favoriteRecipeId)
            getFavorites()
        }
    }
    
    func contains(_ recipe: Recipe) -> Bool {
        userFavoriteRecipes.contains { $0.recipeId == recipe.id.uuidString }
    }
    
}
