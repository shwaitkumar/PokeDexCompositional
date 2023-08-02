//
//  SimpleNetworkHelper.swift
//  ModernPokedex
//
//  Created by Shwait Kumar on 18/01/23.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidUrl
    case invalidData
    case network(Error?)
}

class SimpleNetworkHelper {
    static let shared = SimpleNetworkHelper()
    static let baseUrl = "https://pokedex-bb36f.firebaseio.com/pokemon.json"
    
    func get<T: Decodable>(fromUrl urlString: String, customDecoder: JSONDecoder? = nil) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw DataError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw DataError.invalidResponse
        }
        
        guard let data = data.parseData(removeString: "null,") else {
            throw DataError.invalidData
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension Data {
    func parseData(removeString string: String) -> Data? {
        let dataAsString = String(data: self, encoding: .utf8)
        let parsedDataString = dataAsString?.replacingOccurrences(of: string, with: "")
        guard let data = parsedDataString?.data(using: .utf8) else {
            return nil
        }
        return data
    }
}
