//
//  Webserivce.swift
//  Coffee-Maker
//
//  Created by JINSEOK on 2023/02/08.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

struct Resource<T: Codable> {
    let url: URL
}

class Webservice {
    
    func load<T>(resource: Resource<T>) async -> Result<T, NetworkError> {
        do {
            let (data, response) = try await URLSession.shared.data(from: resource.url)
            
            guard let response = response as? HTTPURLResponse, (200...299) ~= response.statusCode else {
                throw NetworkError.domainError
            }
            
            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                throw NetworkError.decodingError
            }
            
            return .success(result)
            
        } catch {
            return .failure(.urlError)
        }
    }
}
