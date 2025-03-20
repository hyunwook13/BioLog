//
//  BookShelfActionSpy.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/17/25.
//

import Foundation

@testable import BioLog

enum BookShelfActionCall: Equatable {
    case pop
    case pushWithBook(BookDTO)
}

class BookShelfActionSpy: BookShelfActionAble {
    private(set) var callHistory: [BookShelfActionCall] = []
    var passedBook: BookDTO?
    
    func pop() {
        callHistory.append(.pop)
    }
    
    func pushWithBook(book: BioLog.BookDTO) {
        passedBook = book
        callHistory.append(.pushWithBook(book))
    }
    
    
}
