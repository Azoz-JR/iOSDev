//
//  Movie.swift
//  Netflix
//
//  Created by Azoz Salah on 02/02/2023.
//

import Foundation

struct MoviesResponse: Codable {
    let results: [Movie]
}

struct Movie: Identifiable, Codable {
    let id: Int
    let original_language: String
    let original_title: String?
    let overview: String?
    let poster_path: String
    let release_date: String?
    let title: String?
    let vote_average: Double
    let vote_count: Int
    
    var posterURL: URL? {
        return URL(string: "\(Constants.imageBaseURL)\(poster_path)")
    }
    
    var wrappedTitle: String {
        if let name = title {
            return name
        } else {
            return original_title ?? "Unknown title"
        }
    }
    
    var wrappedOverview: String {
        if let overview = overview {
            return overview
        } else {
            return "Unknown Story"
        }
    }
    
}

extension Movie {
    func toItemViewModel() -> ItemViewModel {
        ItemViewModel(id: id, title: wrappedTitle, overview: wrappedOverview, posterURL: posterURL)
    }
}
