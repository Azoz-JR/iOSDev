//
//  ContentView.swift
//  Recipe
//
//  Created by Azoz Salah on 27/05/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    var body: some View {
        TabBar()
            .environmentObject(recipesViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RecipesViewModel())
    }
}
