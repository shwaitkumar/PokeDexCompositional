//
//  PokemonCardView.swift
//  PokemonSwiftUI
//
//  Created by Shwait Kumar on 22/12/24.
//

import SwiftUI

struct PokemonCardView: View {    
    let pokemon: Pokemon
    let cardWidth: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncCachedImage(url: pokemon.imageUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .padding(.horizontal)
            .padding(.horizontal)
            .frame(width: cardWidth, height: cardWidth * 1.25)
            .background(
                RoundedRectangle(cornerRadius: cardWidth / 4)
                    .foregroundStyle(.mintFrost.opacity(0.75))
                    .padding()
                    .visualEffect { content , proxy in
                        let frame = proxy.frame(in: .scrollView(axis: .vertical))
                        
                        return content
                            .hueRotation(.degrees(frame.origin.y / 10))
                    }
            )
            
            Text(pokemon.name.capitalized)
                .font(.title3)
                .fontWeight(.medium)
        } //: VSTACK
    }
}

#Preview {
    PokemonCardView(
        pokemon: Pokemon(
            id: 1,
            attack: 49,
            defense: 49,
            description: "Bulbasaur can be seen napping in bright sunlight.\nThere is a seed on its back. By soaking up the sun’s rays,\nthe seed grows progressively larger.",
            evolutionChain: Optional([PokemonSwiftUI.EvolutionChain(id: "2", name: "ivysaur"), PokemonSwiftUI.EvolutionChain(id: "3", name: "venusaur")]),
            height: 7,
            imageUrl: "https://firebasestorage.googleapis.com/v0/b/pokedex-bb36f.appspot.com/o/pokemon_images%2F2CF15848-AAF9-49C0-90E4-28DC78F60A78?alt=media&token=15ecd49b-89ff-46d6-be0f-1812c948e334",
            name: "bulbasaur",
            type: "poison",
            weight: 69),
        cardWidth: 256
    )
}
