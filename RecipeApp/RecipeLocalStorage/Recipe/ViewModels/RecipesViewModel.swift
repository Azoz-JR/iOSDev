//
//  RecipesViewModel.swift
//  Recipe
//
//  Created by Azoz Salah on 28/05/2023.
//

import Foundation

@MainActor
final class RecipesViewModel: ObservableObject {
    
    @Published private(set) var myRecipes: [Recipe]
    @Published var favorites: [Recipe]
    
    private let savedRecipesPath = getDocumentsDirectory().appending(path: "myRecipes")
    private let savedFavoritesPath = getDocumentsDirectory().appending(path: "favorites")
    
    func addRecipe(recipe: Recipe) {
        myRecipes.append(recipe)
        save()
    }
    
    func contains(_ recipe: Recipe) -> Bool {
        favorites.contains { $0.id == recipe.id }
    }
    
    func addToFavorites(_ recipe: Recipe) {
        objectWillChange.send()
        favorites.insert(recipe, at: 0)
        save()
    }
    
    func removeFromFavorites(_ recipe: Recipe) {
        objectWillChange.send()
        favorites.removeAll { $0.id == recipe.id }
        save()
    }
    
    init() {
        do {
            let recipesData = try Data(contentsOf: savedRecipesPath)
            let favoritesData = try Data(contentsOf: savedFavoritesPath)

            let decodedRecipes = try JSONDecoder().decode([Recipe].self, from: recipesData)
            let decodedFavorites = try JSONDecoder().decode([Recipe].self, from: favoritesData)

            self.myRecipes = decodedRecipes
            self.favorites = decodedFavorites
            return
        } catch {
            print("Failed loading saved data \(error.localizedDescription)")
        }
        
        myRecipes = Bundle.main.decode("recipes.json")
        favorites = []
        save()
    }
    
    func save() {
        do {
            let recipesData = try JSONEncoder().encode(myRecipes)
            let favoritesData = try JSONEncoder().encode(favorites)
            
            try recipesData.write(to: savedRecipesPath, options: [.atomic, .completeFileProtection])
            try favoritesData.write(to: savedFavoritesPath, options: [.atomic, .completeFileProtection])
            
        } catch {
            print("FAILED SAVING RECIPES DATA \(error.localizedDescription)")
        }
    }
    
}
