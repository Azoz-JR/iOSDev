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
    
    @Binding var newRecipe: Recipe?
    
    @State private var recipeName = ""
    @State private var category: Category = .Mains
    @State private var ingredients = ""
    @State private var instructions = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Recipe name", text: $recipeName)
                } header: {
                    Text("Name")
                }
                
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
                
                Section {
                    TextEditor(text: $ingredients)
                } header: {
                    Text("Ingredients")
                }
                
                Section {
                    TextEditor(text: $instructions)
                } header: {
                    Text("Directions")
                }
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveRecipe()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .disabled(recipeName.isEmpty)
                }
                
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
    
    func saveRecipe() {
        let newRecipe = Recipe(id: UUID(), name: recipeName, imageURL: "", category: category.rawValue, ingredients: ingredients.components(separatedBy: .newlines), instructions: instructions.components(separatedBy: .newlines))
        
        recipesViewModel.addRecipe(recipe: newRecipe)
        
        self.newRecipe = newRecipe
        dismiss()
    }
}

struct RecipeForm_Previews: PreviewProvider {
    static var previews: some View {
        RecipeForm(newRecipe: .constant(Recipe.example))
    }
}
