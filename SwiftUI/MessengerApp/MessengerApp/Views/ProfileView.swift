//
//  ProfileView.swift
//  ChatApp
//
//  Created by Azoz Salah on 31/07/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            
            RadialGradient(stops: [
                .init(color: Color(hex: 0x0496ff), location: 0),
                .init(color: .white, location: 0.05)
            ], center: .bottomTrailing, startRadius: 200, endRadius: 205).ignoresSafeArea()
            
            VStack(spacing: 35) {
                Image("profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                
                Text(streamViewModel.currentUser ?? "User")
                    .font(.title.bold())
                
                Button {
                    streamViewModel.signOut()
                    
                    showSignInView = true
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(width: 180)
                        .background {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(hex: 0x0496ff))
                                .shadow(radius: 15)
                        }
                }
            }
            .vSpacing(.top)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView(showSignInView: .constant(false))
                .environmentObject(StreamViewModel())
        }
    }
}
