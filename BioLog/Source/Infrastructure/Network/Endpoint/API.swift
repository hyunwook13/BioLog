//
//  API.swift
//  BioLog
//
//  Created by 이현욱 on 2/26/25.
//

import Foundation

enum BookAPI {
    case searchBooks(title: String)
}

extension BookAPI {
    func asEndpoint<T: Decodable>() -> Endpoint<T> {
        switch self {
        case .searchBooks(let title):
            return Endpoint<T>(
                path: "books/search",
                method: .get,
                queryParameters: ["q": query, "page": String(page)]
            )
            
//        case .detail(let id):
//            return Endpoint<T>(
//                path: "books/\(id)",
//                method: .get
//            )
//            
//        case .relatedBooks(let id, let limit):
//            return Endpoint<T>(
//                path: "books/\(id)/related",
//                method: .get,
//                queryParameters: ["limit": String(limit)]
//            )
//            
//        case .newReleases(let category, let limit):
//            var params: [String: String] = ["limit": String(limit)]
//            if let category = category {
//                params["category"] = category
//            }
//            return Endpoint<T>(
//                path: "books/new-releases",
//                method: .get,
//                queryParameters: params
//            )
        }
    }
}
