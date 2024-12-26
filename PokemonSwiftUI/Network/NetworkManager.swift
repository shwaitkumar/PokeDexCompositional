//
//  NetworkManager.swift
//  PokemonSwiftUI
//
//  Created by Shwait Kumar on 22/12/24.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    static let baseUrl = "https://pokedex-bb36f.firebaseio.com/pokemon.json"

    private init() {}

    // MARK: - Fetch Horoscope
    
    func fetchPokemon() async throws -> [Pokemon] {
        guard let url = URL(string: NetworkManager.baseUrl) else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            guard let data = data.parseData(removeString: "null,") else {
                throw NetworkError.invalidData
            }
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([Pokemon].self, from: data)
            return decodedData
        } catch {
            throw NetworkError.networkError(error.localizedDescription)
        }
    }
    
}

// MARK: - Supporting Types

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidData
    case invalidResponse
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidData:
            return "The data is invalid."
        case .invalidResponse:
            return "The server responded with an invalid response."
        case .networkError(let message):
            return "Network error: \(message)"
        }
    }
}
