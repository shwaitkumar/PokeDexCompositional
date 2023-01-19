//
//  Pokemon.swift
//  ModernPokedex
//
//  Created by Shwait Kumar on 18/01/23.
//

import Foundation

struct Pokemon: Decodable {
    let attack: Int
    let defense: Int
    let description: String
    let evolutionChain: [EvolutionChain]?
    let height: Int
    let id: Int
    let imageUrl: URL
    let name: String
    let type: String
    let weight: Int
}

extension Pokemon: Hashable, Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct EvolutionChain: Decodable {
    let id: String
    let name: String
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
