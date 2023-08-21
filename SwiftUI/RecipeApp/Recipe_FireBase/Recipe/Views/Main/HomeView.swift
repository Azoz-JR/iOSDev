//
//  HomeView.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    let columns = [GridItem(.adaptive(minimum: 160), spacing: 15)]
    
    var body: some View {
        NavigationStack {
            RecipeList()
                .background(LinearGradient(gradient: Gradient(colors: [.yellow.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .navigationTitle("My Recipes")
                .onAppear {
                    //recipesViewModel.downloadRecipesAndUploadToFirebase()
                    recipesViewModel.categorySelected(option: .noCategory)
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(RecipesViewModel())
    }
}
