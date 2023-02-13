//
//  ContentView.swift
//  RollDice
//
//  Created by Azoz Salah on 16/01/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var number = 0
    @State private var numberOfDices = 1
    @State private var numberOfSides = 6
    @State private var rolls: [Int] = []
    @State private var feedBack = UINotificationFeedbackGenerator()
    @State private var degrees = 0
    
    var sides: [Int] {
        var x: [Int] = []
        
        for i in 1...100 {
            if i.isMultiple(of: 2) {
                x.append(i)
            }
        }
        return x
    }
    let savedPath = getDocumentsDirectory().appending(path: "rolls")
    
    @State private var timer: Timer?
        
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                VStack {
                    HStack {
                        Text("Number of dices")
                            .padding()
                        Spacer()
                        Picker("Number of dices", selection: $numberOfDices) {
                            ForEach(1...10, id: \.self) { num in
                                Text(num == 1 ? "1 dice" : "\(num) dices")
                            }
                        }
                    }
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Number of sides")
                            .padding()
                        Spacer()
                        Picker("Number of sides", selection: $numberOfSides) {
                            ForEach(sides, id: \.self) {
                                Text("\($0) sides")
                            }
                        }
                    }
                }
                .background(in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                .padding(.top, 20)
                .padding(.horizontal)

                VStack(spacing: 20) {
                    DiceView(number: number)
                        .rotationEffect(.degrees(Double(degrees)))
                    
                    Button {
                        feedBack.notificationOccurred(.success)
                        withAnimation {
                            if number != 0 {
                                rolls.insert(number, at: 0)
                            }
                            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                                runLoop()
                            })
                        }
                    } label: {
                        Text("Roll")
                            .padding()
                            .font(.headline)
                            .frame(width: 100)
                            .foregroundColor(.white)
                            .background(.blue)
                            .clipShape(Capsule())
                            
                    }
                }
                Spacer()
                PreviousRollsView(rolls: rolls)
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            do {
                let data = try Data(contentsOf: savedPath)
                rolls = try JSONDecoder().decode([Int].self, from: data)
            } catch {
                print("Failed to load saved rolls \(error.localizedDescription)")
            }
            feedBack.prepare()
        }
        .onChange(of: rolls) { _ in
            save()
        }
        .animation(.default, value: degrees)
    }
    
    func rollDice(dices: Int, sides: Int) -> Int {
        var result = 0
        for _ in 0..<dices {
            result += Int.random(in: 1...sides)
        }
        return result
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(rolls)
            try data.write(to: savedPath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save rolls: \(error.localizedDescription)")
        }
    }
    
    func runLoop() {
        degrees += 36
        number = rollDice(dices: numberOfDices, sides: numberOfSides)
        if degrees % 360 == 0 {
            timer?.invalidate()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
