//
//  RecipeList.swift
//  Recipe
//
//  Created by Azoz Salah on 29/05/2023.
//

import SwiftUI

struct RecipeList: View {
    
    @State private var searchedText = ""
    
    var recipes: [Recipe]
    let columns = [GridItem(.adaptive(minimum: 160), spacing: 15)]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(filteredRecipes.count) \(filteredRecipes.count > 1 ? "recipes" : "recipe")")
                .font(.headline)
                .fontWeight(.medium)
                .opacity(0.7)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(filteredRecipes) { recipe in
                        NavigationLink {
                            RecipeView(recipe: recipe)
                        } label: {
                            RecipeCard(recipe: recipe)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.top)
            }
            .searchable(text: $searchedText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search for a recipe")
        }
        .padding(.horizontal)
    }
    
    var filteredRecipes: [Recipe] {
        if searchedText.isEmpty {
            return recipes
        } else {
            return recipes.filter { $0.name.localizedCaseInsensitiveContains(searchedText) }
        }
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeList(recipes: Recipe.all)
        }
    }
}
