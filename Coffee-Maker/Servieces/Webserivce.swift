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

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable> {
    let url: URL?
    var hpptMethod: HttpMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}

class Webservice {
    
    func load<T>(resource: Resource<T>) async throws -> T {
        guard let url = resource.url else { throw NetworkError.urlError }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, (200...299) ~= response.statusCode else {
            throw NetworkError.domainError
        }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return result
    }
}
