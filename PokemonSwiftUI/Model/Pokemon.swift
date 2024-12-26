//
//  Pokemon.swift
//  PokemonSwiftUI
//
//  Created by Shwait Kumar on 22/12/24.
//

import Foundation

struct Pokemon: Identifiable, Decodable {
    let id: Int
    let attack: Int
    let defense: Int
    let description: String
    let evolutionChain: [EvolutionChain]?
    let height: Int
    let imageUrl: String
    let name: String
    let type: String
    let weight: Int
}

struct EvolutionChain: Identifiable, Decodable {
    let id: String
    let name: String
}
