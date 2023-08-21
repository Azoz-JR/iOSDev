//
//  UserOnlineView.swift
//  MessengerApp
//
//  Created by Azoz Salah on 16/08/2023.
//

import SwiftUI

struct UserOnlineView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        Image(systemName: "video.badge.plus")
                            .font(.system(size: 40))
                            .symbolRenderingMode(.multicolor)
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
                        
                        Image("")
                            .resizable()
                            .frame(width: 12, height: 12)
                    }
                    Text("Add")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                ForEach(1..<11, id: \.self) { num in
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            Image("profile")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.gray, lineWidth: 1)
                                }
                            
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.green)
                        }
                        
                        Text("Friend \(num)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                }
            }
        }
        .padding(.top)
    }
}

struct UserOnlineView_Previews: PreviewProvider {
    static var previews: some View {
        UserOnlineView()
    }
}
