//
//  SimpleNetworkHelper.swift
//  ModernPokedex
//
//  Created by Shwait Kumar on 18/01/23.
//

import Foundation

class SimpleNetworkHelper {
    static let shared = SimpleNetworkHelper()
    
    func get<T: Decodable>(fromUrl url: URL, customDecoder: JSONDecoder? = nil, completion: @escaping (T?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                completion(nil)
                return
            }
            
            guard let data = data?.parseData(removeString: "null,") else {
                assertionFailure("No error but also no data?!")
                completion(nil)
                return
            }
            
            let decoder = customDecoder ?? JSONDecoder()
            
            do {
                let decoded = try decoder.decode(T.self, from: data)
                completion(decoded)
            } catch {
                completion(nil)
                print(error)
            }
            
        }.resume()
    }
    
    func fetchPokemon(completion: @escaping ([Pokemon]?) -> ()) {
        self.get(fromUrl: URL(string: "https://pokedex-bb36f.firebaseio.com/pokemon.json")!, completion: completion)
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
