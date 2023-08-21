//
//  CustomChannelHeader.swift
//  ChatApp
//
//  Created by Azoz Salah on 06/08/2023.
//

import SwiftUI
import StreamChatSwiftUI

public struct CustomChannelHeader: ToolbarContent {
    
    @EnvironmentObject var streamViewModel: StreamViewModel

    @Injected(\.fonts) var fonts
    @Injected(\.images) var images

    var title: String
    var onTapLeading: () -> ()

    @State private var callType = "All"
    var calls = ["All", "Missed"]

    public var body: some ToolbarContent {
        
        ToolbarItem(placement: .principal) {
            Text(title)
             .font(fonts.bodyBold)
            
            /*
            Picker("What is your favorite color?", selection: $callType) {
                ForEach(calls, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
             */

        }

        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                DispatchQueue.main.async {
                    streamViewModel.fetchAllChannels()
                }
                
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    streamViewModel.createNewChannel.toggle()
                }
            } label: {
                Image(systemName: "square.and.pencil")
            }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
//            Button {
//                onTapLeading()
//            } label: {
//                Text("Edit")
//            }
            Button {
                streamViewModel.showSearchUsersView = true
            } label: {
                Image(systemName: "plus")
            }

        }
    }
}
