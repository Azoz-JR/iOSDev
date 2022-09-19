//
//  User.swift
//  Archive
//
//  Created by Azoz Salah on 17/08/2022.
//

import Foundation

struct User: Codable,Identifiable {
    var id: UUID
    var isActive: Bool
    let name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friends]
}
