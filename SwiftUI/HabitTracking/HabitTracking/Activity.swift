//
//  Activity.swift
//  HabitTracking
//
//  Created by Azoz Salah on 08/08/2022.
//

import Foundation

struct Activity: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    var count: Int
    var description: String
}
