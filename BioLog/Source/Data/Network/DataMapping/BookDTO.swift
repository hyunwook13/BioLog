//
//  BookDTO.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import Foundation

struct BookDTO {
    let author: String
    let book_description: String
    let id: String
    let is_bookmarked: Bool
    let isbn: String
    let thumbnail: String
}

extension Book {
    func toDTO() -> BookDTO {
        BookDTO(
            author: self.author!,
            book_description: self.book_description!,
            id: self.id!,
            is_bookmarked: self.is_bookmarked,
            isbn: self.isbn!,
            thumbnail: (self.thumbnail?.base64EncodedString())!
        )
    }
}
