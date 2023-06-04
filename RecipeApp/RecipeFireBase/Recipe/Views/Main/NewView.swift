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
            ZStack {
                Color.yellow.opacity(0.6)
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
