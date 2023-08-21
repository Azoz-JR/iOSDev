//
//  CategoryView.swift
//  Recipe
//
//  Created by Azoz Salah on 28/05/2023.
//

import SwiftUI

struct CategoryView: View {
    
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    let category: Category
    
    var filteredRecipes: [Recipe] {
        recipesViewModel.myRecipes.filter { $0.category == category.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            RecipeList(recipes: filteredRecipes)
                .navigationTitle(category.rawValue)
        }

    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: .Mains)
            .environmentObject(RecipesViewModel())
    }
}
