//
//  BookShelfAction.swift
//  BioLog
//
//  Created by 이현욱 on 4/17/25.
//

import Foundation

protocol BookShelfActionAble {
    func pop()
    func pushWithBook(book: BookDTO)
}

struct BookShelfAction: BookShelfActionAble {
    let popHandler: () -> Void
    let pushWithBookHandler: (BookDTO) -> Void
    
    func pop() {
        popHandler()
    }
    
    func pushWithBook(book: BookDTO) {
        pushWithBookHandler(book)
    }
}
