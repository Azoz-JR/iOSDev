//
//  DocumentsDirectory.swift
//  Recipe
//
//  Created by Azoz Salah on 28/05/2023.
//

import Foundation
import SwiftUI

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
