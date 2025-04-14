//
//  Client.swift
//  HaloGlow
//
//  Created by 이현욱 on 1/3/25.
//

import Foundation

protocol Client {
    func request<R: Decodable, E: RequesteResponsable>(with endpoint: E) async throws -> R where E.Response == R
    func request<E: RequesteResponsable>(with endpoint: E) async throws -> Data
}

class ClientImpl: Client {
    let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func request<E: RequesteResponsable>(with endpoint: E) async throws -> Data {
        let urlRequest = try endpoint.getUrlRequest()
        
        let (data,response) = try await session.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unknownError
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.invalidHttpStatusCode(response.statusCode)
        }
        
        return data
    }
    
    func request<R: Decodable, E: RequesteResponsable>(with endpoint: E) async throws -> R where E.Response == R {
        let urlRequest = try endpoint.getUrlRequest()
        
        guard let (data,response) = try? await session.data(for: urlRequest) else { throw NetworkError.unknownError }
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.responseConvertError
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.invalidHttpStatusCode(response.statusCode)
        }
        
        do {
            return try decode(data: data)
        } catch {
            throw NetworkError.emptyData
        }
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}

extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
}
