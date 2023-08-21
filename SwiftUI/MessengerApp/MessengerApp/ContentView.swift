//
//  ContentView.swift
//  MessengerApp
//
//  Created by Azoz Salah on 14/08/2023.
//

import SwiftUI
import StreamChatSwiftUI

struct ContentView: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            ChatChannelListView(viewFactory: CustomViewFactory(), channelListController: streamViewModel.customChannelListController, title: "iChat")
                .tabItem {
                    Label("Chats", systemImage: "message")
                }
                .fullScreenCover(isPresented: $streamViewModel.showSearchUsersView) {
                    SearchUsersView()
                }
                .overlay {
                    ZStack {
                        //LOADING SCREEN...
                        if streamViewModel.isLoading {
                            LoadingScreen()
                        }
                        
                        //New Channel View...
                        if streamViewModel.createNewChannel {
                            CreateNewChannel()
                        }
                    }
                }
            
            EmptyPageView()
                .tabItem {
                    Label("Status", systemImage: "circle.dashed.inset.filled")
                }
            
            EmptyPageView()
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }
            
            EmptyPageView()
                .tabItem {
                    Label("Calls", systemImage: "phone.fill")
                }
            
            ProfileView(showSignInView: $showSignInView)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showSignInView: .constant(false))
            .environmentObject(StreamViewModel())
    }
}
