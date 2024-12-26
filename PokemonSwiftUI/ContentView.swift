//
//  ContentView.swift
//  PokemonSwiftUI
//
//  Created by Shwait Kumar on 26/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var pokemon: [Pokemon] = []
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.seafoamMist, .jadeForest], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            switch pokemon.isEmpty {
            case true:
                PokemonLoadView()
                
            case false:
                PokemonListView(isInitialLoad: true, pokemon: pokemon)
                
            }
        } //: ZSTACK
        .animation(.easeInOut(duration: 0.3), value: pokemon)
        .task { @MainActor in
            do {
                pokemon = try await NetworkManager.shared.fetchPokemon()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
