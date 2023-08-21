//
//  RecipeForm.swift
//  Recipe
//
//  Created by Azoz Salah on 28/05/2023.
//

import SwiftUI

struct RecipeForm: View {
    
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    @Environment(\.dismiss) var dismiss
    
    // State variables for the form
    @State private var recipeName = ""
    @State private var category: Category = .Mains
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var recipeImageURL = ""
    
    var body: some View {
        NavigationView {
            Form {
                // Recipe Name Section
                Section {
                    TextField("Recipe name", text: $recipeName)
                } header: {
                    Text("Name")
                }
                
                // Category Section
                Section {
                    Picker(category.rawValue, selection: $category) {
                        ForEach(Category.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .foregroundColor(.blue)
                } header: {
                    Text("Category")
                }
                
                // Ingredients Section
                Section {
                    TextEditor(text: $ingredients)
                } header: {
                    Text("Ingredients")
                }
                
                // Instructions Section
                Section {
                    TextEditor(text: $instructions)
                } header: {
                    Text("Instructions")
                }
                
                // Image URL Section
                Section {
                    TextField("Image URL", text: $recipeImageURL)
                        .autocapitalization(.none)
                } header: {
                    Text("Recipe's image URL")
                }
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Save Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveRecipe()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .disabled(recipeName.isEmpty)
                }
                
                // Cancel Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
    
    // Save the recipe
    func saveRecipe() {
        let newRecipe = Recipe(
            id: UUID(),
            name: recipeName,
            imageURL: recipeImageURL,
            category: category.rawValue,
            ingredients: ingredients.components(separatedBy: .newlines),
            instructions: instructions.components(separatedBy: .newlines)
        )
        
        // Update ViewModel with new recipe
        recipesViewModel.newRecipe = newRecipe
        
        // Upload the recipe
        try? RecipeManager.shared.uploadRecipe(recipe: newRecipe)
        
        // Dismiss the form
        dismiss()
    }
}


struct RecipeForm_Previews: PreviewProvider {
    static var previews: some View {
        RecipeForm()
    }
}
