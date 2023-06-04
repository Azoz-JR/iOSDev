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
    
    var body: some View {
        NavigationStack {
            RecipeList()
                .navigationTitle(category.rawValue)
                .onAppear {
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
