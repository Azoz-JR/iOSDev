//
//  RecipeCard.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI

struct RecipeCard: View {
    
    let recipe: Recipe
    
    var body: some View {
        VStack {
            // Display the recipe image with recipe name overlay
            AsyncImage(url: recipe.imageUrl) { image in
                image
                    .resizable()
                    .overlay(alignment: .bottom) {
                        Text(recipe.name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 3)
                            .frame(maxWidth: 136)
                            .padding()
                    }
                
            } placeholder: {
                // Placeholder image if recipe image is not available
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit().frame(width: 40, height: 40, alignment: .center)
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(alignment: .bottom) {
                        Text(recipe.name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 3)
                            .frame(maxWidth: 136)
                            .padding()
                    }
            }
        }
        .frame(width: 160, height: 217)
        .background(LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.3), .gray]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
    }
}


struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(recipe: Recipe.all.first!)
    }
}
