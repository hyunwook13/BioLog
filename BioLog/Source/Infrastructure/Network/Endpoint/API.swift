//
//  API.swift
//  BioLog
//
//  Created by 이현욱 on 2/26/25.
//

import Foundation

enum BookAPI {
    case searchBooks(title: String)
    case fetchNewBooks
    
    var baseURL: String {
        switch self {
        case .searchBooks, .fetchNewBooks:
            return "http://www.aladin.co.kr/ttb/api/"
        }
    }
}

extension BookAPI {
    func typedEndpoint<R>() -> Endpoint<R> {
        switch self {
        case .searchBooks(let title):
            return Endpoint<R>(
                baseURL: baseURL,
                path: "ItemSearch.aspx",
                method: .get,
                queryParameters: [
                    "ttbkey": Constant.key,
                    "Query": title,
                    "Cover": "MidBig",
                    "QueryType": "Title",
                    "output":"js",
                    "Version":"20131101"
                ]
            )
            
        case .fetchNewBooks:
            return Endpoint<R>(
                baseURL: baseURL,
                path: "ItemList.aspx",
                method: .get,
                queryParameters: [
                    "ttbkey": Constant.key,
                    "output":"js",
                    "Cover": "MidBig",
                    "QueryType": "ItemNewAll",
                    "Version":"20131101",
                    "SearchTarget": "Book"
                ]
            )
        }
    }
}
