//
//  CategoryView.swift
//  Recipe
//
//  Created by Azoz Salah on 28/05/2023.
//

import SwiftUI

struct CategoryView: View {
    
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    // Grid item layout for recipe list
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    let category: Category
    
    var body: some View {
        NavigationStack {
            // Recipe list view for the selected category
            RecipeList()
                .navigationTitle(category.rawValue)
                .onAppear {
                    // Notify the ViewModel that a category is selected
                    recipesViewModel.categorySelected(option: category)
                }
        }
    }
}


struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: .Mains)
            .environmentObject(RecipesViewModel())
    }
}
