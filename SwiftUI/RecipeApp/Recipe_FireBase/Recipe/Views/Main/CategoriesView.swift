//
//  CategoriesView.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI


struct CategoriesView: View {
    
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 15)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(Category.allCases.dropFirst(), id: \.self) { category in
                        NavigationLink {
                            CategoryView(category: category)
                                .background(LinearGradient(gradient: Gradient(colors: [.green.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        } label: {
                            CategoryCard(category: category)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.top)
            }
            .scrollContentBackground(.hidden)
            .background(LinearGradient(gradient: Gradient(colors: [.green.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .navigationTitle("Categories")
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
            .environmentObject(RecipesViewModel())
    }
}
