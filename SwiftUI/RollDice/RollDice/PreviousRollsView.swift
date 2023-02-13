//
//  PreviousRollsView.swift
//  RollDice
//
//  Created by Azoz Salah on 20/01/2023.
//

import SwiftUI

struct PreviousRollsView: View {
    
    let rolls: [Int]
    
    var body: some View {
        VStack {
            Text("Previous Rolls")
                .font(.headline)
            ZStack {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.white)
                    .shadow(radius: 10)
                    .frame(maxWidth: .infinity, maxHeight: 64)
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(0..<rolls.count, id: \.self) {index in
                            VStack {
                                Text("\(rolls[index])")
                                    .font(.headline)
                                Text("\(index + 1)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct PreviousRollsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousRollsView(rolls: [1,2,3,4,5,6])
    }
}
