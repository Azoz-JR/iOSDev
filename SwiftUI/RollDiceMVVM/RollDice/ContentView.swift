//
//  ContentView.swift
//  RollDice
//
//  Created by Azoz Salah on 16/01/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewViewModel()
    
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
                        Picker("Number of dices", selection: $viewModel.numberOfDices) {
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
                        Picker("Number of sides", selection: $viewModel.numberOfSides) {
                            ForEach(viewModel.sides, id: \.self) {
                                Text("\($0) sides")
                            }
                        }
                    }
                }
                .background(in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                .padding(.top, 20)
                .padding(.horizontal)

                VStack(spacing: 20) {
                    DiceView(number: viewModel.number)
                        .rotationEffect(.degrees(Double(viewModel.degrees)))
                    
                    Button {
                        viewModel.feedBack.notificationOccurred(.success)
                        withAnimation {
                            viewModel.insertRoll()
                            viewModel.runLoop()
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
                PreviousRollsView(rolls: viewModel.rolls)
                    .padding(.bottom, 20)
            }
        }
        .animation(.default, value: viewModel.degrees)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
