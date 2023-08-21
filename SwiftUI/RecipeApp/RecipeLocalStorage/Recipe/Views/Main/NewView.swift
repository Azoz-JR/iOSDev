//
//  NewView.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI

struct NewView: View {
    
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    @State private var showingRecipeForm = false
    @State private var newRecipe: Recipe?
    @State private var showingNewRecipe = false
    
    var body: some View {
        NavigationStack {
            Button("Add recipe manually") {
                showingRecipeForm.toggle()
            }
                .navigationTitle("New Recipe")
                .sheet(isPresented: $showingRecipeForm, onDismiss: {
                    if newRecipe != nil {
                        showingNewRecipe.toggle()
                    }
                }, content: {
                    RecipeForm(newRecipe: $newRecipe)
                        .environmentObject(recipesViewModel)
                })
                .sheet(isPresented: $showingNewRecipe) {
                    if let newRecipe {
                        RecipeView(recipe: newRecipe)
                    }
                }
        }
    }
}

struct NewView_Previews: PreviewProvider {
    static var previews: some View {
        NewView()
    }
}
