//
//  FileManager-DocumentsDirectoy.swift
//  RollDice
//
//  Created by Azoz Salah on 20/01/2023.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
