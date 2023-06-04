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
    
    static let shared = RecipeManager()
    
    private init() {}
    
    private let recipesCollection = Firestore.firestore().collection("recipes")
    
    private func recipeDocument(recipeId: String) -> DocumentReference {
        recipesCollection.document(recipeId)
    }
    
    func getRecipe(recipeId: String) async throws -> Recipe {
        try await recipeDocument(recipeId: recipeId).getDocument(as: Recipe.self)
    }
    
    func uploadRecipe(recipe: Recipe) throws {
        try recipeDocument(recipeId: recipe.id.uuidString).setData(from: recipe, merge: false)
    }
    
    private func getAllRecipesQuery() -> Query {
        recipesCollection
    }
    
    private func getAllRecipesSortedByNameQuery(descending: Bool) -> Query {
        recipesCollection
            .order(by: Recipe.CodingKeys.name.rawValue, descending: descending)
    }
    
    private func getAllRecipesForCategoryQuery(category: String) -> Query {
        recipesCollection
            .whereField(Recipe.CodingKeys.category.rawValue, isEqualTo: category)
    }

    private func getAllRecipesByNameAndCategoryQuery(descending: Bool, category: String) -> Query {
        recipesCollection
            .whereField(Recipe.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Recipe.CodingKeys.name.rawValue, descending: descending)
    }

    func getAllRecipes(nameDescending descending: Bool?, forCategory category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (recipes: [Recipe], lastDocumnet: DocumentSnapshot?) {
        var query: Query = getAllRecipesQuery()

        if let descending, let category {
            query = getAllRecipesByNameAndCategoryQuery(descending: descending, category: category)
        } else if let descending {
            query = getAllRecipesSortedByNameQuery(descending: descending)
        } else if let category {
            query = getAllRecipesForCategoryQuery(category: category)
        }

        return try await query
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Recipe.self)
    }

    func getAllProductsCount() async throws -> Int {
        try await recipesCollection.aggregateCount()
    }
}


extension Query {
    
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        try await getDocumentsWithSnapshot(as: type).recipes
    }
    
    func getDocumentsWithSnapshot<T: Decodable>(as type: T.Type) async throws -> (recipes: [T], lastDocumnet: DocumentSnapshot?) {
        let snapshot = try await self.getDocuments()
        
        let recipes = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
                
        return (recipes, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else {
            return self
        }
        
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
}
