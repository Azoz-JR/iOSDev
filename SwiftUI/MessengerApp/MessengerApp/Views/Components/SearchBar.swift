//
//  SearchBar.swift
//  ChatApp
//
//  Created by Azoz Salah on 31/07/2023.
//

import SwiftUI

struct SearchBar: View {
    
    @EnvironmentObject var streamViewModel: StreamViewModel
    
    var body: some View {
        HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.primary)
                    .font(.title2)
            TextField("Search for users...", text: $streamViewModel.searchText)
                    .font(Font.system(size: 21))
            }
            .padding(7)
            .frame(height: 50)
            .background(.gray.opacity(0.2))
            .cornerRadius(20)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
            .environmentObject(StreamViewModel())
    }
}
