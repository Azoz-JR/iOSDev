//
//  ChannelListHeaderModifier.swift
//  ChatApp
//
//  Created by Azoz Salah on 06/08/2023.
//

import SwiftUI
import StreamChatSwiftUI

struct CustomChannelModifier: ChannelListHeaderViewModifier {

    var title: String

    @State var profileShown = false

    func body(content: Content) -> some View {
        content.toolbar {
            CustomChannelHeader(title: title) {
                profileShown = true
            }
        }
        .sheet(isPresented: $profileShown) {
            SearchUsersView()
        }
    }

}
