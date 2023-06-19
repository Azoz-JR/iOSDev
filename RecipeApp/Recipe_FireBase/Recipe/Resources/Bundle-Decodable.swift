//
//  Bundle-Decodable.swift
//  Recipe
//
//  Created by Azoz Salah on 29/05/2023.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        // Retrieve the URL for the specified file in the bundle
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        // Load the data from the retrieved URL
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        
        // Create a JSON decoder
        let decoder = JSONDecoder()
        
        // Create a date formatter for decoding date values in a specific format
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        // Decode the data into the specified type
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle")
        }
        
        // Return the decoded value
        return loaded
    }
}
