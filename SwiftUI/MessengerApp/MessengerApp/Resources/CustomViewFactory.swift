//
//  CustomViewFactory.swift
//  ChatApp
//
//  Created by Azoz Salah on 06/08/2023.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI


class CustomViewFactory: ViewFactory {
    @Injected(\.chatClient) public var chatClient
    
    
    // 1. Customize the no channels view
//    func makeNoChannelsView() -> some View {
//        NoChannelsYet()
//    }
    
    // 2. Change the channel list background color
//    func makeChannelListBackground(colors: ColorPalette) -> some View {
//        BackgroundView()
//    }

    // 3. Customize the list divider
//    func makeChannelListDividerItem() -> some View {
//        //EmptyView()
//        CustomListRowSeparator()
//    }

    // 4. Add a custom-made channel list header
    func makeChannelListHeaderViewModifier(title: String) -> some ChannelListHeaderViewModifier {
            CustomChannelModifier(title: title)
        }

    // 5. Remove the search bar and add a custom top view
//    func makeChannelListTopView(
//        searchText: Binding<String>
//    ) -> some View {
//        //EmptyView()
//        UserOnlineView()
//    }

    // 6. Add a vertical padding to the top of the channel list
    func makeChannelListModifier() -> some ViewModifier {
        VerticalPaddingViewModifier()
    }

    // 7. Add floating buttons using the footer component
//    public func makeChannelListFooterView() -> some View {
//        UnreadButtonView()
//    }
    
    func makeChannelHeaderViewModifier(for channel: ChatChannel) -> some ChatChannelHeaderViewModifier {
        CustomChatChannelModifier(channel: channel)
    }
    
    func makeEmptyMessagesView(for channel: ChatChannel, colors: ColorPalette) -> some View {
        Text("No messages yet, enter the first one by tapping on the composer at the bottom of the screen.")
            .padding()
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color(UIColor.secondarySystemBackground), lineWidth: 2)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
    }

    // 8. Make a tab bar using the sticky footer component
//    func makeChannelListStickyFooterView() -> some View {
//        WhatsAppTabView()
//    }
    
    
//    func makeMessageTextView(for message: ChatMessage,
//                             isFirst: Bool,
//                             availableWidth: CGFloat) -> some View {
//        return CustomMessageTextView(message: message, isFirst: isFirst)
//    }
//
//    func makeCustomAttachmentViewType(for message: ChatMessage, isFirst: Bool, availableWidth: CGFloat) -> some View {
//        CustomAttachmentView(message: message, width: availableWidth, isFirst: isFirst)
//    }
    
}
