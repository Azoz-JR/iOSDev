//
//  Save-Load.swift
//  Challenge7
//
//  Created by Azoz Salah on 28/09/2022.
//

import Foundation

func save(notes: [Notes]) {
    let jsonEncoder = JSONEncoder()
    if let decodedNotes = try? jsonEncoder.encode(notes) {
        let defaults = UserDefaults.standard
        defaults.set(decodedNotes, forKey: "notes")
    } else {
        print("Failed to save Notes")
    }
}
