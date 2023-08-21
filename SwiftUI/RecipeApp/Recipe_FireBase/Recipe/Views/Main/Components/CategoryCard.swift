//
//  CategoryCard.swift
//  Recipe
//
//  Created by Azoz Salah on 06/06/2023.
//

import SwiftUI

struct CategoryCard: View {
    
    let category: Category
    
    var body: some View {
        VStack {
            // Display the image for the category
            Image(category.rawValue)
                .resizable()
                .background(LinearGradient(gradient: Gradient(colors: [.green.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .opacity(0.85)
                .overlay(alignment: .bottom) {
                    // Display the category name as an overlay
                    Text(category.rawValue)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3)
                        .frame(maxWidth: 136)
                        .padding()
                }
            
        }
        .frame(width: 160, height: 217)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
    }
}


struct CategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCard(category: .Sides)
    }
}
