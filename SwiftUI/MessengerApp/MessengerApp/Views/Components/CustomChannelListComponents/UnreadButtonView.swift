//
//  UnreadButtonView.swift
//  MessengerApp
//
//  Created by Azoz Salah on 16/08/2023.
//

import SwiftUI

struct UnreadButtonView: View {
    var body: some View {
        Button {
            print("Jump to unread messages button tapped")
        } label: {
            Image(systemName: "arrow.up")
            Text("Jump to unread")
        }
        .buttonStyle(.borderedProminent)
    }
}

struct UnreadButtonView_Previews: PreviewProvider {
    static var previews: some View {
        UnreadButtonView()
    }
}
