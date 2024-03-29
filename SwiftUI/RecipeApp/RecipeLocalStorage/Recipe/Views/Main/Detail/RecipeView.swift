//
//  RecipeView.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI

struct RecipeView: View {
    
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    var recipe: Recipe
    
    var body: some View {
            ScrollView {
                VStack {
                    AsyncImage(url: recipe.imageUrl, content: { image in
                        image
                            .resizable()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                        
                    }) {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40, alignment: .center)
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .frame(height: 300)
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.3), .gray]), startPoint: .top, endPoint: .bottom))
                    
                    Text(recipe.name)
                        .font(.largeTitle.bold())
                        .padding(.vertical)
                    
                    VStack(alignment: .leading) {
                        Text("Ingredients")
                            .padding(.vertical)
                            .font(.headline)
                        
                        Text(recipe.ingredients.joined(separator: "\n"))
                        
                        Text("Directions")
                            .font(.headline)
                            .padding(.vertical)
                        
                        Text(recipe.instructions.joined(separator: "\n"))
                        
                        Button(recipesViewModel.contains(recipe) ? "Remove from Favorites" : "Add to Favorites") {
                            if recipesViewModel.contains(recipe) {
                                recipesViewModel.removeFromFavorites(recipe)
                            } else {
                                recipesViewModel.addToFavorites(recipe)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.vertical)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                .padding(.bottom, 10)
            }
            .ignoresSafeArea(edges: .top)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: Recipe.example)
            .environmentObject(RecipesViewModel())
    }
}
