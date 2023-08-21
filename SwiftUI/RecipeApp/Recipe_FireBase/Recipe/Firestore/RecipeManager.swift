//
//  RecipeManager.swift
//  Recipe
//
//  Created by Azoz Salah on 02/06/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


final class RecipeManager {
    
    // Singleton instance of RecipeManager
    static let shared = RecipeManager()
    
    private init() {}
    
    private let recipesCollection = Firestore.firestore().collection("recipes")
    
    // Returns the document reference for a recipe with the given recipeId
    private func recipeDocument(recipeId: String) -> DocumentReference {
        recipesCollection.document(recipeId)
    }
    
    // Retrieves a recipe from the database with the given recipeId
    func getRecipe(recipeId: String) async throws -> Recipe {
        try await recipeDocument(recipeId: recipeId).getDocument(as: Recipe.self)
    }
    
    // Uploads a recipe to the database
    func uploadRecipe(recipe: Recipe) throws {
        try recipeDocument(recipeId: recipe.id.uuidString).setData(from: recipe, merge: false)
    }
    
    // Returns the base query for retrieving all recipes
    private func getAllRecipesQuery() -> Query {
        recipesCollection
    }
    
    // Returns the query for retrieving all recipes sorted by name
    private func getAllRecipesSortedByNameQuery(descending: Bool) -> Query {
        recipesCollection
            .order(by: Recipe.CodingKeys.name.rawValue, descending: descending)
    }
    
    // Returns the query for retrieving all recipes for a specific category
    private func getAllRecipesForCategoryQuery(category: String) -> Query {
        recipesCollection
            .whereField(Recipe.CodingKeys.category.rawValue, isEqualTo: category)
    }
    
    // Returns the query for retrieving recipes by name and category, with sorting option
    private func getAllRecipesByNameAndCategoryQuery(descending: Bool, category: String) -> Query {
        recipesCollection
            .whereField(Recipe.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Recipe.CodingKeys.name.rawValue, descending: descending)
    }
    
    // Retrieves a specified number of recipes based on sorting and filtering options
    func getAllRecipes(nameDescending descending: Bool?, forCategory category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (recipes: [Recipe], lastDocument: DocumentSnapshot?) {
        var query: Query = getAllRecipesQuery()
        
        if let descending = descending, let category = category {
            query = getAllRecipesByNameAndCategoryQuery(descending: descending, category: category)
        } else if let descending = descending {
            query = getAllRecipesSortedByNameQuery(descending: descending)
        } else if let category = category {
            query = getAllRecipesForCategoryQuery(category: category)
        }
        
        return try await query
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Recipe.self)
    }
    
    // Retrieves the total count of recipes in the database
    func getAllRecipesCount() async throws -> Int {
        try await recipesCollection.aggregateCount()
    }
}


extension Query {
    
    // Retrieves documents from the query and decodes them as an array of a specified type
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        try await getDocumentsWithSnapshot(as: type).recipes
    }
    
    // Retrieves documents from the query and returns them with the last document snapshot
    func getDocumentsWithSnapshot<T: Decodable>(as type: T.Type) async throws -> (recipes: [T], lastDocument: DocumentSnapshot?) {
        let snapshot = try await self.getDocuments()
        
        let recipes = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
        return (recipes, snapshot.documents.last)
    }
    
    // Starts the query after a specified document snapshot if provided
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument = lastDocument else {
            return self
        }
        
        return self.start(afterDocument: lastDocument)
    }
    
    // Retrieves the count of documents from the query using aggregation
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
}
