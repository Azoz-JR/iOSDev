//
//  CustomChatChannelHeader.swift
//  MessengerApp
//
//  Created by Azoz Salah on 18/08/2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI


public struct CustomChatChannelHeader: ToolbarContent {

    public var channelName: String
    public var channel: ChatChannel
    public var onTapTrailing: () -> ()
    
    private func isActive(_ channel: ChatChannel) -> Bool {
        let count = channel.lastActiveMembers.filter { member in
            member.isOnline
        }
        .count
        
        // 1 is the current user
        return count > 1
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack(alignment: .leading) {
                Text(channelName)
                    .font(.headline)
                
                if isActive(channel) {
                    Text("Active now")
                        .foregroundColor(.secondary)
                }
            }
            .hLeading()
            .padding(.leading, 5)
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                Button {
                    //Start a voive call
                } label: {
                    Image(systemName: "phone.fill")
                }
                
                Button {
                    //Start a video call
                } label: {
                    Image(systemName: "video.fill")
                }


            }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink(destination: ChatChannelInfoView(channel: channel)) {
                AsyncImage(url: channel.imageURL) { image in
                    if let image = image.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .modifier(CircleImageModifier())
                    } else {
                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .modifier(CircleImageModifier())
                            .if(isActive(channel), transform: { content in
                                content
                                    .modifier(ActiveViewModifier())
                            })
                    }
                }
            }
        }
    }
}


struct CustomChatChannelModifier: ChatChannelHeaderViewModifier {

    @State private var editShown = false
    var channel: ChatChannel

    func body(content: Content) -> some View {
        content
            .toolbar {
                CustomChatChannelHeader(channelName: channel.name ?? "UNKNOWN", channel: channel) {
                editShown = true
            }
        }
        .sheet(isPresented: $editShown) {
            Text("Edit View")
        }
    }
}
