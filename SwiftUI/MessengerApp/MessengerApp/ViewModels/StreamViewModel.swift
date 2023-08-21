//
//  StreamViewModel.swift
//  ChatApp
//
//  Created by Azoz Salah on 06/08/2023.
//

import Foundation
import SwiftUI
import StreamChat
import StreamChatSwiftUI


extension ChatClient {
    static var shared: ChatClient!
}


@MainActor
final class StreamViewModel: ObservableObject {
    
    @Published var userName = ""
    @Published var showSignInView = false
    
    @AppStorage("userName") var storedUser = ""
    @AppStorage("log_Status") var logStatus = false
    
    //Error Alert Variables
    @Published var error = false
    @Published var errorMsg = ""
    
    //Search bar text
    @Published var showSearchUsersView = false
    @Published var searchText = ""
    @Published var searchResults: [ChatUser] = []
    
    @Published var isLoading = false
    
    //Create new channel...
    @Published var channelName = ""
    @Published var createNewChannel = false
    
    //Open direct channel
    @Published var showingSelectedChannel = false
    @Published var selectedChannelController: ChatChannelController? = nil
    @Published var selectedChannelListViewModel: ChatChannelListViewModel? = nil
    @Published var selectedChannelViewModel: ChatChannelViewModel? = nil
    
    @Published var customChannelListController: ChatChannelListController? = {
        if let id = ChatClient.shared.currentUserId {
            let controller = ChatClient.shared.channelListController(
                query: .init(
                    filter: .and([.equal(.type, to: .messaging), .containMembers(userIds: [id])]),
                    sort: [.init(key: .lastMessageAt, isAscending: false)],
                    pageSize: 10
                )
            )
            return controller
        } else {
            return nil
        }
    }()
    
    var isSignedIn: Bool {
        ChatClient.shared.currentUserId != nil
    }
    
    var currentUser: String? {
        ChatClient.shared.currentUserId
    }
    
    func signOut() {
        if currentUser != nil {
            ChatClient.shared.logout {
                print("Client logged out")
            }
        } else {
            print("ERROR LOGGING OUT")
        }
    }
    
    func signIn(username: String, completion: @escaping (Bool) -> ()) {
        guard let token = tokens[username] else {
            self.errorMsg = "Sorry, we don't recognize this username"
            self.error.toggle()
            return
        }
        
        ChatClient.shared.connectUser(userInfo: UserInfo(id: username, name: username), token: Token(stringLiteral: token)) { error in
            if let error = error {
                self.errorMsg = error.localizedDescription
                self.error.toggle()
                return
            }
            
            print("\(username) LOGGED IN SUCCESSFULLY!")
            completion(error == nil)
        }
        
    }
    
    func deleteChannel(name: String) {
        let controller = ChatClient.shared.channelController(for: .init(type: .messaging, id: name))
        
        controller.deleteChannel { error in
            if let error = error {
                print("ERROR deleting CHANNEL: \(error.localizedDescription)")
                self.channelName = ""
                withAnimation {
                    self.createNewChannel = false
                }
            }
            
            self.channelName = ""
            withAnimation {
                self.createNewChannel = false
            }
        }
    }
    
    func createChannel() {
        guard let current = currentUser, !channelName.isEmpty else {
            self.errorMsg = "User isn't logged in"
            self.error.toggle()
            return
        }
        
        let keys: [String] = tokens.keys.filter({ $0 != current }).map { $0 }
        
        withAnimation {
            isLoading = true
        }
        
        let channelId = ChannelId(type: .messaging, id: channelName)
        
        do {
            let request = try ChatClient.shared.channelController(createChannelWithId: channelId, name: channelName, imageURL: nil, members: Set(keys), isCurrentUserMember: true)
            
            request.synchronize { [weak self] error in
                withAnimation {
                    self?.isLoading = false
                }
                
                if let error = error {
                    self?.errorMsg = error.localizedDescription
                    print("ERROR CREATING NEW CHANNEL : \(error.localizedDescription)")
                    self?.error.toggle()
                    
                    withAnimation {
                        self?.createNewChannel = false
                    }
                    return
                }
                
                //else Successful...
                print("\(self?.channelName ?? "") CHANNEL CREATED SUCCESSFULLY!")
                self?.channelName = ""
                withAnimation {
                    self?.createNewChannel = false
                }
            }
        } catch {
            print("ERROR Creating CHANNEL: \(error.localizedDescription)")
        }
    }
    
    func createDirectChannel(id: String) {
        guard currentUser != nil, !id.isEmpty else {
            self.errorMsg = "User isn't logged in"
            self.error.toggle()
            return
        }
        
        withAnimation {
            isLoading = true
        }
        
        do {
            let request = try ChatClient.shared.channelController(createDirectMessageChannelWith: Set([id]), type: .messaging, isCurrentUserMember: true, name: id, extraData: [:])
            
            request.synchronize { [weak self] error in
                withAnimation {
                    self?.isLoading = false
                }
                
                if let error = error {
                    self?.errorMsg = error.localizedDescription
                    print("ERROR CREATING NEW CHANNEL : \(error.localizedDescription)")
                    self?.error.toggle()
                    
                    return
                }
                
                //else Successful...
                print("\(id) CHANNEL CREATED SUCCESSFULLY!")
                
                self?.selectedChannelViewModel = ChatChannelViewModel(channelController: request)
                
                self?.selectedChannelController = request
                
                self?.showingSelectedChannel = true
            }
        } catch {
            print("ERROR Creating Direct CHANNEL: \(error.localizedDescription)")
            return
        }
    }
    
    func fetchAllChannels() {
        guard let user = currentUser else {
            print("ERROR FINDING CUREENT USER")
            return
        }
        
        print("STARTING CHANNELS QUERY....")
        
        withAnimation {
            isLoading = true
        }
        
        let request = ChatClient.shared.channelListController(
            query: .init(
                filter: .containMembers(userIds: [user]),
                pageSize: 10
            )
        )
        
        // Get the first 10 channels
        request.synchronize { error in
            
            withAnimation {
                self.isLoading = false
            }
            
            if let error = error {
                print("ERROR QUERYING CHANNELS: \(error.localizedDescription)")
                self.errorMsg = error.localizedDescription
                self.error.toggle()
                
                return
            }
            
            // Get the next 10 channels
            request.loadNextChannels { error in
                // handle error / access channels
                if let error {
                    print("ERROR LOADING NEXT CHANNELS: \(error.localizedDescription)")
                }
            }
            print("ALL CHANNELS FETCHED SUCCESSFULLY!")
            print("CHANNELS COUNT: \(request.channels.count)")
        }
        
    }
    
    func searchUsers(searchText: String) {
        
        let controller = ChatClient.shared.userListController(query: .init(filter: .autocomplete(.name, text: searchText), pageSize: 10))
        
        controller.synchronize { [weak self] error in
            if let error = error {
                print("ERROR SEARCHING FOR USER: \(error.localizedDescription)")
                self?.errorMsg = "ERROR SEARCHING FOR USER: \(error.localizedDescription)"
                self?.error.toggle()
                return
            }
            
            print("SEARCHED FIRST PAGE SUCCESSFULLY")
            
            self?.searchResults = controller.users.filter { $0.id.description != self?.currentUser}
            
            controller.loadNextUsers(limit: 10) { error in
                if let error = error {
                    print("ERROR SEARCHING FOR NEXT USERS: \(error.localizedDescription)")
                    self?.errorMsg = "ERROR SEARCHING FOR USER: \(error.localizedDescription)"
                    self?.error.toggle()
                    return
                }
                
                self?.searchResults = controller.users.filter { $0.id.description != self?.currentUser}
                print("SEARCHED SECOND PAGE SUCCESSFULLY")
            }
        }
    }
    
}
