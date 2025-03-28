//
//  CompleteBook.swift
//  BioLog
//
//  Created by 이현욱 on 4/14/25.
//

import Foundation

struct CompleteBook: Equatable {
    static func == (lhs: CompleteBook, rhs: CompleteBook) -> Bool {
        lhs.detail.isbn == rhs.detail.isbn
    }
    
    var detail: BookDTO
    var category: CategoryDTO
    var bookmark: BookmarkDTO?
    var characters: [CharacterDTO]
}

extension CompleteBook {
    static var empty: CompleteBook {
        return CompleteBook(detail: BookDTO.empty,
                            category: .empty,
                            characters: [])
    }
}

//
//struct HistoryDTO {
//    
//}
