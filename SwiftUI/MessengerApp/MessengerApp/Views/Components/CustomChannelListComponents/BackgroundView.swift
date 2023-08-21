//
//  BackgroundView.swift
//  MessengerApp
//
//  Created by Azoz Salah on 16/08/2023.
//

import SwiftUI

struct BackgroundView: View {
    
    let color = LinearGradient(gradient: Gradient(colors: [Color(hex: 0xedf2fb), Color(hex: 0xe2eafc), Color(hex: 0xd9ed92), Color(hex: 0xb5e48c), Color(hex: 0x99d98c), Color(hex: 0x76c893)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    let color2 = LinearGradient(gradient: Gradient(colors: [Color(hex: 0xedf2fb), Color(hex: 0xe2eafc)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    let color3 = RadialGradient(stops: [
        .init(color: Color(hex: 0xd9ed92), location: 0.3),
        .init(color: Color(red: 0.76, green: 0.20, blue: 0.45), location: 0.3)
    
    ], center: .top, startRadius: 400, endRadius: 700)
    
    let color4 = RadialGradient(gradient: Gradient(stops: [
        .init(color: Color(hex: 0xd9ed92), location: 0),
        .init(color: Color(hex: 0x99d98c), location: 1)
    ]), center: .top, startRadius: 100, endRadius: 900)
    
    var body: some View {
        color2.ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
