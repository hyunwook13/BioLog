//
//  SearchBookActionSpy.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/17/25.
//

import Foundation

@testable import BioLog

enum SearchBookActionCall: Equatable {
    case cancel
    case selected(CompleteBook)
}

final class SearchBookActionSpy: SearchBookActionAble {
    private(set) var callHistory: [SearchBookActionCall] = []
    var passedCompleteBook: CompleteBook?
    
    func cancel() {
        callHistory.append(.cancel)
    }
    
    func selected(_ book: BioLog.CompleteBook) {
        passedCompleteBook = book
        callHistory.append(.selected(book))
    }
}
