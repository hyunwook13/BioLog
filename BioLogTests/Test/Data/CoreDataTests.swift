//
//  CoreDataTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/3/25.
//

import Foundation
import XCTest

@testable import BioLog

class CoreDataTests: XCTestCase {
    
    var testCoredataStack: BioLogCoreDataTestStack!
    var coreData: CoreData!
    
    override func setUp() {
        self.testCoredataStack = BioLogCoreDataTestStack()
        self.coreData = CoreData(mainContext: testCoredataStack.mainContext, container: nil)
    }
    
//    override func tearDown() {
//        testCoredataStack = nil
//        coreData = nil
//    }
    
    func test_코아데이터_생성_테스트() {
        
        // given
        let sampleBooks = BookDummy.sampleBooks
        
        // when 
        for book in sampleBooks {
            let createdBook = coreData.create(book)
            
            // then
            XCTAssertNotNil(createdBook)
            
            // Observable로 감싸진 Book 객체 테스트
            _ = createdBook.subscribe(onNext: { bookObject in
                XCTAssertEqual(bookObject.title, book.title)
                XCTAssertEqual(bookObject.author, book.author)
                XCTAssertEqual(bookObject.book_description, book.description)
                XCTAssertEqual(bookObject.isbn, book.isbn)
                XCTAssertEqual(bookObject.cover, book.cover)
                XCTAssertEqual(bookObject.pubDate, book.pubDate)
                XCTAssertEqual(bookObject.categoryName, book.categoryName)
            })
        }
        

    }
    
//    func test_데이터생성후_데이터조회() {
//        // when
//        let fetchedBooks = coreData.fetch(Book.self)
//        
//        _ = fetchedBooks.subscribe(onNext: { bookObject in
//            // then
//            XCTAssertEqual(bookObject.count, 5)
//        })
//    }
}
