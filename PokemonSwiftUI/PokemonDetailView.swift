//
//  PokemonDetailView.swift
//  PokemonSwiftUI
//
//  Created by Shwait Kumar on 22/12/24.
//

import SwiftUI

struct PokemonDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let pokemon: Pokemon
    let cardWidth: CGFloat // To Set same corner radius as card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(.vertical) {
                    ZStack {
                        RoundedRectangle(cornerRadius: cardWidth / 4)
                            .foregroundStyle(.seafoamMist)
                        
                        if horizontalSizeClass == .regular {
                            HStack(alignment: .center) {
                                pokemonBriefInfoView()
                                
                                pokemonDetailsView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                                    .background(
                                        Color.jadeForest
                                    )
                            } //: HSTACK
                        }
                        else {
                            VStack(alignment: .center) {
                                pokemonBriefInfoView()
                                
                                pokemonDetailsView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                    .background(
                                        Color.jadeForest
                                    )
                            } //: VSTACK
                        }
                    } // : ZSTACK
                    .clipShape(RoundedRectangle(cornerRadius: cardWidth / 4))
                    .padding()
                    .padding()
                } //: SCROLLVIEW
            } //: ZSTACK
            .toolbarVisibility(.hidden)
            .background(
                Color.mintFrost
            )
            .overlay {
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }, label: {
                            HStack {
                                Image(systemName: "xmark")
                                
                                Text("Close")
                            } //: HSTACK
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.jadeForest)
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .foregroundStyle(.white)
                                    .shadow(color: .jadeForest.opacity(0.8), radius: cardWidth / 4)
                            )
                        })
                        .padding(.horizontal)
                        .padding()
                        
                        Spacer()
                    } //: HSTACK
                    
                    Spacer()
                } //: VSTACK
            }
        }
    }
    
    private func pokemonBriefInfoView() -> some View {
        VStack {
            AsyncCachedImage(url: pokemon.imageUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .padding([.horizontal, .bottom])
            
            Text(pokemon.name.capitalized)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.jadeForest)
                .shadow(color: .seafoamMist, radius: 2)
            
            HStack {
                Image(pokemon.type)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding([.leading, .vertical], 8)
                
                Text("\(pokemon.type.capitalized)")
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding([.trailing, .vertical], 8)
                    .padding(.horizontal)
            } //: HSTACK
            .background(
                Capsule()
                    .foregroundStyle(.white)
            )
        } //: VSTACK
        .padding()
    }
    
    private func pokemonDetailsView() -> some View {
        ZStack {
            VStack(spacing: 20) {
                Text(pokemon.description)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                VStack {
                    Text("Height: \(pokemon.height)dm")
                    Text("Weight: \(pokemon.weight)hg")
                    Text("Attack: \(pokemon.attack)units")
                    Text("Defense: \(pokemon.defense)units")
                } //: VSTACK
                .font(.title3)
                .fontWeight(.medium)
            } //: VSTACK
            .foregroundStyle(.white)
        } //: ZSTACK
        .padding()
    }
}

#Preview {
    PokemonDetailView(pokemon:
                        Pokemon(
                            id: 1,
                            attack: 49,
                            defense: 49,
                            description: "Bulbasaur can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun’s rays, the seed grows progressively larger.",
                            evolutionChain: Optional([PokemonSwiftUI.EvolutionChain(id: "2", name: "ivysaur"), PokemonSwiftUI.EvolutionChain(id: "3", name: "venusaur")]),
                            height: 7,
                            imageUrl: "https://firebasestorage.googleapis.com/v0/b/pokedex-bb36f.appspot.com/o/pokemon_images%2F2CF15848-AAF9-49C0-90E4-28DC78F60A78?alt=media&token=15ecd49b-89ff-46d6-be0f-1812c948e334",
                            name: "bulbasaur",
                            type: "poison",
                            weight: 69),
                      cardWidth: 128
    )
}
