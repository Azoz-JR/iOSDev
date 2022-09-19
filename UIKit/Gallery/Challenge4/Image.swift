//
//  Image.swift
//  Challenge4
//
//  Created by Azoz Salah on 13/09/2022.
//

import Foundation

class Image: Codable {
    var name: String
    var caption: String
    
    init(name: String, caption: String) {
        self.name = name
        self.caption = caption
    }
}
