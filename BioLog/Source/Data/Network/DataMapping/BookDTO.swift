//
//  BookDTO.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import Foundation
import CoreData

struct BookResponse: Codable {
    let item: [BookDTO]
}

// MARK: - 개별 책(Item) 구조체
struct BookDTO: Codable, Equatable {
    static func == (lhs: BookDTO, rhs: BookDTO) -> Bool {
        return lhs.isbn == rhs.isbn
    }
    
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
    let publisher: String
    let customerReviewRank: Int16
    
    var createdAt: Date = Date()
    var isBookmarked: Bool = false
    var category: CategoryDTO = .empty
    var characters: [CharacterDTO] = []
    
    var originalObject: Book?
    
    enum CodingKeys: String, CodingKey {
        case isbn = "isbn13"
        case title, /*link*/ author, pubDate, description, /*priceSales*/ /*priceStandard*/ cover, categoryName, publisher, customerReviewRank
    }
}

// 2. BookDTO가 CoreDataConvertible을 준수하도록 확장
extension BookDTO: CoreDataConvertible {
    func toCoreDataObject(in context: NSManagedObjectContext) -> Book {
        let desc = NSEntityDescription.entity(forEntityName: "Book", in: context)!
        let book = Book(entity: desc, insertInto: context)
        book.book_description = self.description
        book.author = self.author
        book.title = self.title
        book.id = UUID().uuidString
        book.isbn = self.isbn
        book.cover = self.cover
        book.pubDate = self.pubDate
        book.categoryName = self.categoryName
        book.publisher = self.publisher
        return book
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
            publisher: "",
//            publisher: "",
            customerReviewRank:1,
            category: .empty
        )
    }
}


extension Book {
    func toDTO() -> BookDTO {
        let characters = self.characters?.allObjects as? [BookCharacter]
        
        return BookDTO(
            title: self.title!,
            author: self.author!,
            pubDate: self.pubDate!,
            description: self.book_description!,
            isbn: self.isbn!,
            cover: self.cover!,
            categoryName: self.categoryName!,
            publisher: self.publisher!,
            customerReviewRank: self.customerReviewRank,
            createdAt: self.createdAt ?? Date(),
            isBookmarked: true,
            category: self.category?.toDTO() ?? .empty,
            characters: characters?.compactMap { $0.toDTO() } ?? [],
            originalObject: self
        )
    }
}

