//
//  DocumentsDirectory.swift
//  Challenge4
//
//  Created by Azoz Salah on 13/09/2022.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func save(pictures: [Image]) {
    if let savedImages = try? JSONEncoder().encode(pictures) {
        UserDefaults.standard.set(savedImages, forKey: "pictures")
    }
}
