//
//  Test.swift
//  MessengerApp
//
//  Created by Azoz Salah on 18/08/2023.
//

import SwiftUI

struct Test: View {
    
    @State private var next = false
    @State private var selected: Int? = 0
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Button("NAVIGATE ->") {
                    selected = 12
                }
                
                NavigationLink(tag: 12, selection: $selected) {
                    Text("HELLO")
                } label: {
                    EmptyView()
                }
            }
        }


    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
