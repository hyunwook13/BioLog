//
//  MainActionSpy.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/7/25.
//

import Foundation

@testable import BioLog

enum MainActionCall: Equatable {
    case present
    case selectedReadingBook(CompleteBook)
    case selectedNewBook(CompleteBook)
    case chart
}

class MainActionSpy: MainActionAble {

    private(set) var callHistory: [MainActionCall] = []
    var passedCompleteBook: CompleteBook?
    
    func add() {
        self.callHistory.append(.present)
    }
    func selectedReadingBook(with book: BioLog.CompleteBook) {
        self.passedCompleteBook = book
        self.callHistory.append(.selectedReadingBook(book))
    }
    
    func selectedNewBook(with book: BioLog.CompleteBook) {
        self.passedCompleteBook = book
        self.callHistory.append(.selectedNewBook(book))
    }
    
    func chart() {
        self.callHistory.append(.chart)
    }
}
