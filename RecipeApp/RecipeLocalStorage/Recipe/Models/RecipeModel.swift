//
//  RecipeModel.swift
//  RecipeModel
//
//  Created by Azoz Salah on 28/05/2023.
//

import Foundation

enum Category: String, CaseIterable, Codable {
    case Breakfast, Soups, Salads, Appetizers, Mains, Sides, Desserts, Snacks, Drinks
}

struct Recipe: Codable, Identifiable {
    let id: UUID
    let name: String
    let imageURL: String
    let category: Category.RawValue
    let ingredients: [String]
    let instructions: [String]
    
    var imageUrl: URL? {
        return URL(string: imageURL)
    }
    
    static func ==(lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    static let example = Recipe(id: UUID(), name: "Pasta", imageURL: "", category: "Mains", ingredients: ["test"], instructions: ["aaa"])
    
    static let all: [Recipe] = Bundle.main.decode("recipes.json")
    
}
