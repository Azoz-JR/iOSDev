//
//  ContentView.swift
//  RockPaperScissor
//
//  Created by Azoz Salah on 23/07/2022.
//

import SwiftUI

struct PickImage: View {
var text: String

var body: some View {
    Image(text)
        .resizable()
        .frame(width: 110.0, height: 260.0)
        //.renderingMode(.original)
        .clipShape(Capsule())
        .shadow(radius: 5)
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var picks = ["Rock", "Paper", "Scissor"]
    @State private var computerAnswer = Int.random(in: 0...2)
    @State private var you = 0
    @State private var computer = 0
    @State private var rounds = 1
    @State private var result = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [ .blue, .mint]), startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
            VStack(spacing: 10) {
                Spacer()
                Text("ROUND \(rounds)")
               
                Spacer()
                
                HStack {
                    Text("YOU")
                        .padding()
                    Text("Computer")
                        .padding()
                }
                .foregroundColor(.white)
                .font(.largeTitle.bold())
                HStack {
                    Spacer()
                    Text("\(you)")
                    Spacer()
                    Text("\(computer)")
                    Spacer()
                }
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                HStack(spacing: 20) {
                    ForEach(0..<3) { pick in
                        Button {
                            pickTapped(pick)
                        } label: {
                            PickImage(text: picks[pick])
                        }
                    }
                }
                .padding()
                Group {
                    Text("Take your pick")
                    Spacer()
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .font(.largeTitle.bold())
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if rounds < 10 {
                Button("Continue", action: askQuestion)
            }else {
                Button("Play Again", action: restart)
            }
        }message: {
            if rounds == 10 {
                Text("\(result)")
            }
        }
    }
    
    func pickTapped(_ pick: Int) {
        if pick == computerAnswer {
            scoreTitle = "TIE!"
        } else if win(pick)  {
            scoreTitle = "YOU WIN!"
            you += 1
        }else {
            scoreTitle = "YOU LOSE!"
            computer += 1
        }
        
        rounds += 1
        if rounds == 10 {
            if you > computer {
                result = "YOU WON THE GAME!"
            }else if you < computer {
                result = "YOU LOST THE GAME!"
            }else {
                result = "TIE!"
            }
        }
        showingScore = true
    }
    
    func askQuestion () {
        computerAnswer = Int.random(in: 0...2)
    }
    
    func restart() {
        you = 0
        computer = 0
        rounds = 1
    }
    
    func win(_ pick: Int) -> Bool {
        if (pick == 0 && computerAnswer == 2) || (pick == 1 && computerAnswer == 0) || (pick == 2 && computerAnswer == 1) {
            return true
        }else {
            return false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ContentView()
        }
    }
}
