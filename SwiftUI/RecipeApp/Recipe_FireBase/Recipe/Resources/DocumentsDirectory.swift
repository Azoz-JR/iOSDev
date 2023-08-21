//
//  DocumentsDirectory.swift
//  Recipe
//
//  Created by Azoz Salah on 28/05/2023.
//

import Foundation
import SwiftUI

func getDocumentsDirectory() -> URL {
    // Get the URLs for the document directory of the user's domain mask
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    // Return the first URL in the paths array, which represents the documents directory
    return paths[0]
}

