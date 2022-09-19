//
//  QuestionsView.swift
//  EdutainmentChallenge
//
//  Created by Azoz Salah on 13/08/2022.
//

import SwiftUI

struct QuestionsView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var questionsNumber: Int
    @Binding var selectedDifficulity: String
    
    @State private var acceptButtons = Array(repeating: false, count: 20)
    @State private var showingScore = false
    @State private var score = 0
    @State private var Easy = createArray(min: 1, max: 10, count: 21)
    @State private var Normal = createArray(min: 11, max: 20, count: 21)
    @State private var Hard = createArray(min: 21, max: 50, count: 21)
    @FocusState private var answerIsFocused: Bool
    @State private var answers = Array(repeating: 0, count: 20)
    @State private var correctAnswers = [Int]()
    
    var body: some View {
        List {
            ForEach(0..<questionsNumber, id: \.self) {i in
                Section(
                    header: Text("Question \(i + 1)")
                            .font(.subheadline.bold())
                            .foregroundColor(.primary)
                ){
                    if selectedDifficulity.hasPrefix("Easy") {
                        Text("\(Easy[i]) * \(Easy[i+1]) = ")
                        HStack {
                            TextField("Write your answer here", value: $answers[i], format: .number)
                                .font(.subheadline.bold())
                                .foregroundColor(.primary)
                                .keyboardType(.numberPad)
                                .focused($answerIsFocused)
                            
                            Button("Accept") {
                                acceptButtons[i] = true
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
                                acceptButtons[i] = true
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
                                acceptButtons[i] = true
                                insertAnswer(num1: Hard[i], num2: Hard[i+1], answer: answers[i])
                            }
                        }
                    }
                }
                .disabled(acceptButtons[i])
                
            }
            Section{
                Button() {
                    showingScore = true
                }label: {
                    Text("Finish")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .listRowBackground(Color.blue)
        }
        .alert("Your score is \(score) / \(questionsNumber)", isPresented: $showingScore) {
            Button("Restart") {
                restart()
                dismiss()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done") {
                    answerIsFocused = false
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("PlayGround")
        .navigationBarTitleDisplayMode(.inline)
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
        acceptButtons = Array(repeating: false, count: 20)
        showingScore = false
        Easy = QuestionsView.createArray(min: 1, max: 10, count: 21)
        Normal = QuestionsView.createArray(min: 11, max: 20, count: 21)
        Hard = QuestionsView.createArray(min: 21, max: 50, count: 21)
        
    }
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView(questionsNumber: .constant(1), selectedDifficulity: .constant("Easy"))
    }
}
