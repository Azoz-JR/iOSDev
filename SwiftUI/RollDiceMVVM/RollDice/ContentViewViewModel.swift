//
//  ContentViewViewModel.swift
//  RollDice
//
//  Created by Azoz Salah on 21/01/2023.
//

import Foundation
import SwiftUI

@MainActor class ContentViewViewModel: ObservableObject {
    @Published var number = 0
    @Published var numberOfDices = 1
    @Published var numberOfSides = 6
    @Published var rolls: [Int] = []
    @Published var feedBack = UINotificationFeedbackGenerator()
    @Published var degrees = 0
    @Published var timer: Timer?
    
    let savedPath = getDocumentsDirectory().appending(path: "rolls")
    
    var sides: [Int] {
        var x: [Int] = []
        
        for i in 1...100 {
            if i.isMultiple(of: 2) {
                x.append(i)
            }
        }
        return x
    }
    
    init() {
        loadData()
        feedBack.prepare()
    }
    
    func insertRoll() {
        if number != 0 {
            rolls.insert(number, at: 0)
            save()
        }
    }
    
    
    func rollDice(dices: Int, sides: Int) -> Int {
        var result = 0
        for _ in 0..<dices {
            result += Int.random(in: 1...sides)
        }
        return result
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(rolls)
            try data.write(to: savedPath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save rolls: \(error.localizedDescription)")
        }
    }
    
    func loadData() {
        do {
            let data = try Data(contentsOf: savedPath)
            rolls = try JSONDecoder().decode([Int].self, from: data)
        } catch {
            print("Failed to load saved rolls \(error.localizedDescription)")
        }
    }
    
    func runLoop() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            Task {
                await MainActor.run {
                    self.rollRotation()
                }
            }
            
        })
    }
    
    func rollRotation() {
        degrees += 36
        number = rollDice(dices: numberOfDices, sides: numberOfSides)
        if degrees % 360 == 0 {
            timer?.invalidate()
        }
    }
    
}
