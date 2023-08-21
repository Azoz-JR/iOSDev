//
//  RecipeModel.swift
//  RecipeModel
//
//  Created by Azoz Salah on 28/05/2023.
//

import Foundation

enum Category: String, CaseIterable, Codable {
    case noCategory, Breakfast, Soups, Salads, Appetizers, Mains, Sides, Desserts, Snacks, Drinks
    
    var categoryKey: String? {
        if self == .noCategory {
            return nil
        } else {
            return self.rawValue
        }
    }
}

struct Recipe: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let imageURL: String
    let category: Category.RawValue
    let ingredients: [String]
    let instructions: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL
        case category
        case ingredients
        case instructions
    }
    
    var imageUrl: URL? {
        return URL(string: imageURL)
    }
    
    static func ==(lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    // An example recipe for testing or demonstration purposes
    static let example = Recipe(id: UUID(), name: "Pasta", imageURL: "", category: "Mains", ingredients: ["test"], instructions: ["aaa"])
    
    // Load all recipes from a JSON file
    static let all: [Recipe] = Bundle.main.decode("recipes.json")
}

