//
//  PokemonListView.swift
//  PokemonSwiftUI
//
//  Created by Shwait Kumar on 22/12/24.
//

import SwiftUI

struct PokemonListView: View {
    @State private var isAnimating: Bool = false
    @State private var pokemon: [Pokemon] = []
    @Namespace private var namespace
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    Image("PokemonLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * (UITraitCollection.current.horizontalSizeClass == .regular ? 0.2 : 0.3), height: geometry.size.width * (UITraitCollection.current.horizontalSizeClass == .regular ? 0.1 : 0.15))
                        .offset(y: isAnimating ? .zero : geometry.frame(in: .local).midY - 20)
                        .animation(.easeInOut(duration: 0.8).delay(0.3), value: isAnimating)
                    
                    ScrollView {
                        LazyVGrid(columns: UITraitCollection.current.horizontalSizeClass == .regular ? [GridItem(), GridItem(), GridItem(), GridItem()] : [GridItem(), GridItem()]) {
                            ForEach(pokemon) { pokemon in
                                NavigationLink {
                                    PokemonDetailView(pokemon: pokemon, cardWidth: UITraitCollection.current.horizontalSizeClass == .regular ? geometry.size.width / 4 : geometry.size.width / 2)
                                        .navigationTransition(
                                            .zoom(
                                                sourceID: pokemon.id,
                                                in: namespace
                                            )
                                        )
                                    
                                } label: {
                                    PokemonCardView(
                                        pokemon: pokemon,
                                        cardWidth: UITraitCollection.current.horizontalSizeClass == .regular ? geometry.size.width / 4 : geometry.size.width / 2
                                    )
                                    .matchedTransitionSource(
                                        id: pokemon.id,
                                        in: namespace
                                    )
                                    .visualEffect { content, proxy in
                                        let frame = proxy.frame(in: .scrollView(axis: .vertical))
                                        
                                        // The distance this view extends past the bottom edge
                                        // of the scroll view.
                                        let distance = min(0, frame.minY)
                                        
                                        return content
                                            .scaleEffect(1 + distance / 700)
                                            .offset(y: -distance / 1.25)
                                            .blur(radius: -distance / 50)
                                    }
                                }
                                .foregroundStyle(.black) // To make text bright black
                            }
                        } //: LAZYVGRID
                        .scrollTargetLayout()
                        .padding(.horizontal)
                    } //: SCROLLVIEW
                    .scrollTargetBehavior(.viewAligned)
                } //: VSTACK
                .background(
                    LinearGradient(colors: [.seafoamMist, .jadeForest], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .onAppear {
                    isAnimating.toggle()
                }
                .task { @MainActor in
                    do {
                        pokemon = try await NetworkManager.shared.fetchPokemon()
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            } //: NAVIGATION STACK
        }
    }
}

#Preview {
    PokemonListView()
}
