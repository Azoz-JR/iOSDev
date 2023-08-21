//
//  SearchUsersView.swift
//  MessengerApp
//
//  Created by Azoz Salah on 19/08/2023.
//

import StreamChat
import StreamChatSwiftUI
import SwiftUI

struct SearchUsersView: View {
        
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button {
                    streamViewModel.showSearchUsersView = false
                    streamViewModel.searchText = ""
                    streamViewModel.searchResults = []
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                TextField("Search for users", text: $streamViewModel.searchText)
                    .font(.title2)
                    .padding()
                    .frame(height: 45)
                    .padding(.leading)
            }
            .frame(height: 50)
            .padding(.horizontal)
            
            Rectangle()
                .frame(height: 0.2)
                .frame(maxWidth: .infinity)
                .background(.gray)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(streamViewModel.searchResults) { user in
                        Button {
                            DispatchQueue.main.async {
                                streamViewModel.createDirectChannel(id: user.id.description)
                            }
                        } label: {
                            HStack {
                                MessageAvatarView(avatarURL: user.imageURL)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.id)
                                        .lineLimit(1)
                                        .font(.headline)
                                    
                                    if user.isOnline {
                                        Text("Active Now")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    } else if let lastSeen = user.lastActiveAt {
                                        Text(lastSeenTime(from: lastSeen))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .foregroundColor(.primary)
                            }
                            .hLeading()
                            .padding()
                        }
                    }
                }
                .onChange(of: streamViewModel.searchText) { newValue in
                    if !newValue.isEmpty {
                        streamViewModel.searchUsers(searchText: newValue)
                    }
                }
            }
        }
        .alert("ERROR CREATING NEW DIRECT CHANNEL...", isPresented: $streamViewModel.error) {
            Button("OK") {}
        } message: {
            Text(streamViewModel.errorMsg)
        }
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                TextField("Search for users", text: $streamViewModel.searchText)
//                    .padding()
//                    .frame(height: 50)
//                    .frame(maxWidth: .infinity)
//                    .background(.gray)
//                    .padding(.leading)
//            }
//        }
        .fullScreenCover(isPresented: $streamViewModel.showingSelectedChannel) {
            NavigationStack {
                Group {
                    if let channelController = streamViewModel.selectedChannelController {
                        LazyView(
                            ChatChannelView(viewFactory: CustomViewFactory(), viewModel: streamViewModel.selectedChannelViewModel
                                            , channelController: channelController)
                        )
                    } else {
                        Text("SOMETHING WENT WRONG!!!!")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            streamViewModel.showingSelectedChannel = false
                        } label: {
                            Image(systemName: "arrow.left")
                        }
                    }
                }
            }
        }
//        .fullScreenCover(isPresented: $streamViewModel.showingSelectedChannel) {
//            NavigationStack {
//                Group {
//                    if let viewModel = streamViewModel.selectedChannelListViewModel {
//                        ChatChannelListView(viewFactory: CustomViewFactory(), viewModel: viewModel, embedInNavigationView: false)
//                    } else {
//                        Text("SOMETHING WENT WRONG!!!!")
//                    }
//                }
//                .onAppear {
//                    if let channel = streamViewModel.selectedChannelController?.channel {
//                        streamViewModel.selectedChannelListViewModel?.selectedChannel = ChannelSelectionInfo(channel: channel, message: nil)
//                    }
//                }
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button {
//                            streamViewModel.showingSelectedChannel = false
//                        } label: {
//                            Image(systemName: "arrow.left")
//                        }
//                    }
//                }
//            }
//        }
    }
}

struct SearchUsersView_Previews: PreviewProvider {
    static var previews: some View {
            SearchUsersView()
                .environmentObject(StreamViewModel())
    }
}
