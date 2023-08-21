//
//  CustomListRowSeparator.swift
//  MessengerApp
//
//  Created by Azoz Salah on 16/08/2023.
//

import SwiftUI

struct CustomListRowSeparator: View {
    
    let deviceWidth = UIScreen.main.bounds.width
    let color = LinearGradient(gradient: Gradient(colors: [Color(hex: 0xedf2fb), Color(hex: 0xe2eafc)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: deviceWidth, height: 1)
            .blendMode(.screen)
    }
}

struct CustomListRowSeparator_Previews: PreviewProvider {
    static var previews: some View {
        CustomListRowSeparator()
    }
}
