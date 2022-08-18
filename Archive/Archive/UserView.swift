//
//  UserView.swift
//  Archive
//
//  Created by Azoz Salah on 17/08/2022.
//

import SwiftUI

struct UserView: View {
    let user: User
    
    
    var body: some View {
        Form {
            Section {
                Text("Name: \(user.name)")
                Text("ID: \(user.id)")
                Text(user.isActive ? "Status: Active" : "Status: Inactive")
                Text("Age: \(user.age)")
                Text("Company: \(user.company)")
                Text("Email: \(user.email)")
                Text("Address: \(user.address)")
                Text("About: \(user.about)")
                Text("Registered: \(user.registered)")
                
            }header: {
                Text("User Data")
                    .font(.headline.bold())
                    .foregroundColor(.primary)
            }
            
            Section {
                ForEach(user.tags, id: \.self) { tag in
                    Text("\(tag)")
                }
            }header: {
                Text("User Tags")
                    .font(.headline.bold())
                    .foregroundColor(.primary)
            }
            
            Section {
                ForEach(user.friends) { friend in
                    VStack(alignment: .leading) {
                        Text("Name: \(friend.name)")
                        Text("ID: \(friend.id)")
                    }
                }
            }header: {
                Text("Friends")
                    .font(.headline.bold())
                    .foregroundColor(.primary)
            }
        }
        .navigationTitle("\(user.name)")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(hex: 0xF5E8C7))
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: User(id: UUID(), isActive: true, name: "Karim", age: 34, company: "Real Madrid", email: "karim19@gmail.com", address: "Madrid", about: "Best player in the world", registered: Date.now, tags: [], friends: []))
    }
}
