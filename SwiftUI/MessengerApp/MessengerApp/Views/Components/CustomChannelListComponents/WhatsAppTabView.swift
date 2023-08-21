//
//  WhatsAppTabView.swift
//  MessengerApp
//
//  Created by Azoz Salah on 16/08/2023.
//

import SwiftUI

struct WhatsAppTabView: View {
    
    let deviceWidth = UIScreen.main.bounds.width
    let color = LinearGradient(gradient: Gradient(colors: [Color(hex: 0x4cc9f0), Color(hex: 0x4361ee)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var body: some View {
        VStack {
            TwitterComposeButtonView()
            
            TabView {
                Rectangle()
                    .tabItem {
                        Label("Status", systemImage: "circle.dashed.inset.filled")
                    }
                
                EmptyPageView()
                    .tabItem {
                        Label("Calls", systemImage: "phone.fill")
                    }
                EmptyPageView()
                    .tabItem {
                        Label("Camera", systemImage: "camera")
                    }
                EmptyPageView()
                    .tabItem {
                        Label("Chats", systemImage: "message")
                    }
                    .badge(12)
                
                EmptyPageView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .frame(width: deviceWidth, height: 48)
        }
    }
    
}

struct WhatsAppTabView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsAppTabView()
    }
}
