//
//  NewView.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI

struct NewView: View {
    
    // Access the RecipesViewModel from the environment
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    @State private var showingRecipeForm = false
    @State private var showingNewRecipe = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow.opacity(0.6)
                
                // Button to add a recipe manually
                Button {
                    showingRecipeForm.toggle()
                } label: {
                    Text("Add recipe manually")
                        .frame(width: 240, height: 50)
                        .background(Color(hex: 0x40B5AD))
                        .font(.headline)
                        .foregroundColor(Color(hex: 0x152238))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .ignoresSafeArea()
            
            .navigationTitle("New Recipe")
            
            // Present the recipe form as a sheet when showingRecipeForm is true
            .sheet(isPresented: $showingRecipeForm, onDismiss: {
                if recipesViewModel.newRecipe != nil {
                    showingNewRecipe.toggle()
                }
            }, content: {
                RecipeForm()
                    .environmentObject(recipesViewModel)
            })
            
            // Clear the newRecipe value in the view model when showingNewRecipe is true
            .sheet(isPresented: $showingNewRecipe) {
                recipesViewModel.newRecipe = nil
            } content: {
                // Present the new recipe view if a newRecipe exists in the view model
                if let newRecipe = recipesViewModel.newRecipe {
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
