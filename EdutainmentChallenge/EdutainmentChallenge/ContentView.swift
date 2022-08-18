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
                NavigationLink {
                    QuestionsView(questionsNumber: $questionsNumber, selectedDifficulity: $selectedDifficulity)
                }label: {
                    Section{
                        Text("Play")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .listRowBackground(Color.blue)
                
            }
            .background(LinearGradient(gradient: Gradient(colors: [.green, .mint]), startPoint: .leading, endPoint: .trailing))
            .navigationTitle("Multiplication Game")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
