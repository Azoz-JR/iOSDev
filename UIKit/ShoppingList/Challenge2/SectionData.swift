//
//  SectionData.swift
//  Challenge2
//
//  Created by Azoz Salah on 18/09/2022.
//

import Foundation

struct SectionData {
    let title: String
    let data: [String]
    
    var numberOfItems: Int {
        return data.count
    }
    
    subscript(index: Int) -> String {
        return data[index]
    }
}

extension SectionData {
    init(title: String, data: String) {
        self.title = title
        self.data = [data]
    }
}
