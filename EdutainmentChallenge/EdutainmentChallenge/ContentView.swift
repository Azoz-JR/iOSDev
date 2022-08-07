//
//  ContentView.swift
//  EdutainmentChallenge
//
//  Created by Azoz Salah on 29/07/2022.
//

import SwiftUI

struct FontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline.bold())
            .foregroundColor(.black)
    }
}

extension View {
    func fontModification() -> some View {
        modifier(FontModifier())
    }
}

struct ContentView: View {
    @State private var selectedNumber = 2
    @State private var questionsNumber = 1
    @State private var selectedDifficulity = "Easy"
    @FocusState private var answerIsFocused: Bool
    @State private var answers = Array(repeating: 0, count: 20)
    @State private var score = 0
    @State private var correctAnswers = [Int]()
    @State private var showingScore = false
    @State private var isPlaying = false
    @State private var playButton = true
    @State private var acceptButtons = [Bool]()
    @State private var acceptButton = true
    @State private var Easy = createArray(min: 1, max: 10, count: 21)
    @State private var Normal = createArray(min: 11, max: 20, count: 21)
    @State private var Hard = createArray(min: 21, max: 50, count: 21)
    
    let difficulities = ["Easy", "Normal", "Hard"]
    
    
    
    
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section{
                    Stepper("\(selectedNumber)'s Table", value: $selectedNumber, in: 2...12)
                    
                    Section {
                        ForEach(1...12, id: \.self) { number in
                            Text("\(selectedNumber)  *  \(number)  =  \(selectedNumber * number )")
                        }
                    }
                    .font(.headline.bold())
                }header: {
                    Text("Practice Area")
                        .fontModification()
                }
                
                Section {
                    Picker(questionsNumber == 1 ? "\(questionsNumber) Question" : "\(questionsNumber) Questions", selection: $questionsNumber) {
                        ForEach(1...20, id: \.self) {
                            Text("\($0)")
                                .font(.subheadline.bold())
                                .foregroundColor(.primary)
                        }
                    }
                }header: {
                    Text("Select the number of questions")
                        .fontModification()
                }
                
                Section {
                    Picker("Select question's Difficulity", selection: $selectedDifficulity) {
                        ForEach(difficulities, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                }header: {
                    Text("Select question's Difficulity")
                        .fontModification()
                }
                if playButton {
                    Section{
                        HStack {
                            Spacer()
                            Button("Play") {
                                withAnimation {
                                    for _ in 0..<questionsNumber {
                                        acceptButtons.append(true)
                                    }
                                    isPlaying = true
                                    playButton = false
                                }
                            }
                            Spacer()
                        }
                        .listRowBackground(Color.blue)
                        .font(.headline.bold())
                        .foregroundColor(.white)
                    }
                }
                
                if isPlaying {
                    Section {
                        ForEach(0..<questionsNumber, id: \.self) {i in
                            Section {
                                if selectedDifficulity.hasPrefix("Easy") {
                                    Text("\(Easy[i]) * \(Easy[i+1]) = ")
                                        HStack {
                                            TextField("Write your answer here", value: $answers[i], format: .number)
                                                .font(.subheadline.bold())
                                                .foregroundColor(.primary)
                                                .keyboardType(.numberPad)
                                                .focused($answerIsFocused)
                                            
                                            Button("Accept") {
                                                acceptButton = false
                                                insertAnswer(num1: Easy[i], num2: Easy[i+1], answer: answers[i])
                                            }
                                        }
                                    
                                } else if selectedDifficulity.hasPrefix("Normal") {
                                    Text("\(Normal[i]) * \(Normal[i+1]) = ")
                                    HStack {
                                        TextField("Write your answer here", value: $answers[i], format: .number)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.primary)
                                            .keyboardType(.numberPad)
                                            .focused($answerIsFocused)
                                        Button("Accept") {
                                            insertAnswer(num1: Normal[i], num2: Normal[i+1], answer: answers[i])
                                        }
                                    }
                                    
                                } else if selectedDifficulity.hasPrefix("Hard"){
                                    Text("\(Hard[i]) * \(Hard[i+1]) = ")
                                    HStack {
                                        TextField("Write your answer here", value: $answers[i], format: .number)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.primary)
                                            .keyboardType(.numberPad)
                                            .focused($answerIsFocused)
                                        Button("Accept") {
                                            insertAnswer(num1: Hard[i], num2: Hard[i+1], answer: answers[i])
                                        }
                                    }
                                }
                            }header: {
                                Text("Question \(i + 1)")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    Section{
                        HStack {
                            Spacer()
                            Button("Finish") {
                                showingScore = true
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.blue)
                    .font(.headline.bold())
                    .foregroundColor(.white)
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [.green, .mint]), startPoint: .leading, endPoint: .trailing))
            .navigationTitle("Multiplication Game")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        answerIsFocused = false
                    }
                }
            }
        }
        .alert("Your score is \(score) / \(questionsNumber)", isPresented: $showingScore)
        {
            Button("Play Again") {
                restart()
            }
        }
    }
    
    static func createArray(min: Int, max: Int, count:Int) -> [Int] {
        var array = [Int]()
        while array.count < count {
            for _ in 0..<count {
                array.append(Int.random(in: min...max))
            }
        }
        return array
    }
    
    func insertAnswer(num1: Int, num2: Int,answer: Int) {
        if answer == num1 * num2 {
            score += 1
        }else {
            return
        }
    }
    
    func restart() {
        score = 0
        answers = Array(repeating: 0, count: 20)
        correctAnswers.removeAll()
        acceptButtons.removeAll()
        showingScore = false
        isPlaying = false
        playButton = true
        Easy = ContentView.createArray(min: 1, max: 10, count: 21)
        Normal = ContentView.createArray(min: 11, max: 20, count: 21)
        Hard = ContentView.createArray(min: 21, max: 50, count: 21)
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ContentView()
        }
    }
}
