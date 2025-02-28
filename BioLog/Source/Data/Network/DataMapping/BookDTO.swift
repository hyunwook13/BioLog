//
//  BookDTO.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import Foundation

struct BookResponse: Codable {
    let item: [BookDTO]
}

// MARK: - 개별 책(Item) 구조체
struct BookDTO: Codable {
    
    let title: String
//    let link: String? // 알라딘 책 링크
    let author: String
    let pubDate: String
    let description: String  // 책 설명
//    let isbn: String?
    let isbn: String // 표준 2007년 이후 사용
//    let priceSales: Int
//    let priceStandard: Int
    let cover: String
    let categoryName: String
//    let publisher: String
    let customerReviewRank: Int16
    
    enum CodingKeys: String, CodingKey {
        case isbn = "isbn13"
        case title, /*link*/ author, pubDate, description, /*priceSales*/ /*priceStandard*/ cover, categoryName, /*publisher*/ customerReviewRank
    }
}

extension BookDTO {
    static var empty: Self {
        return BookDTO(
            title: "",
            author: "",
            pubDate: "",
            description: "",
            isbn: "",
//            priceSales: 1,
//            priceStandard: 1,
            cover: "",
            categoryName: "",
//            publisher: "",
            customerReviewRank:1
        )
    }
}


extension Book {
    func toDTO() -> BookDTO {
        BookDTO(
            title: self.title!,
            author: self.author!,
            pubDate: self.pubDate!,
            description: self.book_description!,
            isbn: self.isbn!,
            cover: self.cover!,
            categoryName: self.categoryName!,
            customerReviewRank: self.customerReviewRank
        )
    }
}

