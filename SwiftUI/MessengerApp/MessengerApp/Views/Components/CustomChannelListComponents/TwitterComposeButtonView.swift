//
//  TwitterComposeButtonView.swift
//  MessengerApp
//
//  Created by Azoz Salah on 16/08/2023.
//

import SwiftUI

struct TwitterComposeButtonView: View {
    
    let color = LinearGradient(gradient: Gradient(colors: [Color(hex: 0x4cc9f0), Color(hex: 0x4361ee)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var body: some View {
        HStack {
            Spacer()
            
            Image(systemName: "plus.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white)
                .shadow(radius: 5)
        }
    }
}

struct TwitterComposeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TwitterComposeButtonView()
    }
}
