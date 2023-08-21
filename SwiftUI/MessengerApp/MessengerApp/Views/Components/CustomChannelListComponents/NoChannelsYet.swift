//
//  NoChannelsYet.swift
//  MessengerApp
//
//  Created by Azoz Salah on 16/08/2023.
//

import SwiftUI

struct NoChannelsYet: View {
    var body: some View {
        VStack {
            Image(systemName: "message")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
                .frame(width: 150, height: 100)
            
            Text("Sorry, No channels yet!!!")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct NoChannelsYet_Previews: PreviewProvider {
    static var previews: some View {
        NoChannelsYet()
    }
}
