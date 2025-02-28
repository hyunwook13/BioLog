//
//  Service.swift
//  HaloGlow
//
//  Created by 이현욱 on 1/23/25.
//

import Foundation

protocol Service {
    func fetch() async throws -> Data
}

protocol BookService {
    func fetchBooks(with id: String) -> [BookDTO]
//    func deleteBook(with id: String) -> BookDTO
//    func updateBook(with data: BookDTO) -> BookDTO
//    func fetchBook(with id: String) -> BookDTO
    
}

//protocol Provider {
//    func makeClient(_ config: Config) -> Client
//}

//class ServiceImpl: Service {
//    let provider: Provider
//    
//    init(provider: Provider) {
//        self.provider = provider
//    }
//    
//    func fetch() async throws -> Data {
//        let client = provider.makeClient()
//        
//        client.request(with: <#T##RequesteResponsable#>)
//        return Data()
////        return try await client.request(with: <#T##RequesteResponsable#>)
//    }
//}


//class BookServiceImpl: BookService {
//    let provider: Provider
//    
//        init(provider: Provider) {
//            self.provider = provider
//        }
//    
//    
//    
//    func fetchBooks(with id: String) -> [BookDTO] {
//        let client = provider.makeClient(Config.searchBook)
//        
//        BookAPI.searchBooks(title: id).asEndpoint().
//        
//        Task {
//            do {
//                let data = try await client.request(with: APIEndpoints.getBooksInfo(with: id))
//            } catch {
//                
//            }
//        }
//    }
//}
