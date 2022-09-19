//
//  ContentView.swift
//  Archive
//
//  Created by Azoz Salah on 17/08/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var users = [User]()
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: 0xE8F9FD).ignoresSafeArea()
                
                List(users) { user in
                    NavigationLink {
                        UserView(user: user)
                    }label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(user.name)
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(user.isActive ? .green : .red)
                                Text(user.isActive ? "Active" : "Inactive")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .task {
                    await loadData()
                }
                
                .navigationTitle("Archive")
            }
        }
    }
    
    func loadData() async {
        if users.isEmpty {
            guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
                print("Invalid URL")
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let decodedResponse = try? decoder.decode([User].self, from: data) {
                    users = decodedResponse
                }
            } catch {
                print("Invalid Data")
            }
        }else {
            return
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
