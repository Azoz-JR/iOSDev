//
//  UserManager.swift
//  Recipe
//
//  Created by Azoz Salah on 31/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let recipes: [Recipe]?
    let favoriteRecipes: [Recipe]?
    
    init(userId: String, isAnonymous: Bool? = nil, email: String? = nil, photoUrl: String? = nil, dateCreated: Date? = nil, isPremium: Bool? = nil, preferences: [String]? = nil, recipes: [Recipe]? = nil, favoriteRecipes: [Recipe]? = nil) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.recipes = recipes
        self.favoriteRecipes = favoriteRecipes
    }
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoURL
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.recipes = nil
        self.favoriteRecipes = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "user_ispremium"
        case preferences = "preferences"
        case recipes = "recipes"
        case favoriteRecipes = "favorite_recipes"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.recipes = try container.decodeIfPresent([Recipe].self, forKey: .recipes)
        self.favoriteRecipes = try container.decodeIfPresent([Recipe].self, forKey: .favoriteRecipes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.recipes, forKey: .recipes)
        try container.encodeIfPresent(self.favoriteRecipes, forKey: .favoriteRecipes)
    }
    
}


final class UserManager {
    
    static let shared = UserManager()
    
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func userFavoriteRecipeCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_recipes")
    }
    
    private func userFavoriteRecipeDocument(userId: String, favoriteRecipeId: String) -> DocumentReference {
        userFavoriteRecipeCollection(userId: userId).document(favoriteRecipeId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()

    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
        
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayUnion([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeUserPreference(userId: String, preference: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue : FieldValue.arrayRemove([preference])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addUserFavoriteRecipe(userId: String, recipeId: String, recipeName: String) async throws {
        let document = userFavoriteRecipeCollection(userId: userId).document()
        let documnetId = document.documentID

        let data: [String: Any] = [
            UserFavoriteRecipe.CodingKeys.id.rawValue: documnetId,
            UserFavoriteRecipe.CodingKeys.recipeId.rawValue: recipeId,
            UserFavoriteRecipe.CodingKeys.dateCreated.rawValue: Timestamp(),
            UserFavoriteRecipe.CodingKeys.recipeName.rawValue: recipeName
        ]

        try await document.setData(data, merge: false)
    }

    func removeUserFavoriteRecipe(userId: String, favoriteRecipeId: String) async throws {
        try await userFavoriteRecipeDocument(userId: userId, favoriteRecipeId: favoriteRecipeId).delete()
    }

    func getAllUserFavoriteRecipes(userId: String) async throws -> [UserFavoriteRecipe] {
        try await userFavoriteRecipeCollection(userId: userId).getDocuments(as: UserFavoriteRecipe.self)
    }
    
}


struct UserFavoriteRecipe: Codable, Identifiable {
    let id: String
    let recipeId: String
    let dateCreated: Date
    let recipeName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case recipeName = "name"
        case recipeId = "recipe_id"
        case dateCreated = "date_created"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.recipeId = try container.decode(String.self, forKey: .recipeId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.recipeName = try container.decode(String.self, forKey: .recipeName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.recipeId, forKey: .recipeId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.recipeName, forKey: .recipeName)
    }
    
}
