//
//  Country.swift
//  Challenge5
//
//  Created by Azoz Salah on 18/09/2022.
//

import Foundation

struct Country: Codable {
    var name: String
    var code: String
    var capital: String
    var region: String
    var currency: Currency
    var language: Language
    var flag: String
    
    struct Language: Codable {
        var code: String?
        var name: String
    }
    
    struct Currency: Codable {
        var code: String
        var name: String
        var symbol: String?
    }

}
