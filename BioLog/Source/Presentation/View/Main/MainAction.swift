//
//  MainAction.swift
//  BioLog
//
//  Created by 이현욱 on 4/7/25.
//

import Foundation

protocol MainActionAble {
    func add()
    func selectedReadingBook(with book: CompleteBook)
    func selectedNewBook(with book: CompleteBook)
    func chart()
}

struct MainAction: MainActionAble {
    let addHandler: () -> Void
    let selectedReadingBookHandler: (CompleteBook) -> Void
    let selectedNewBookHandler: (CompleteBook) -> Void
    let chartHandler: () -> Void
    
    func add() {
        addHandler()
    }
    
    func selectedReadingBook(with book: CompleteBook) {
        selectedReadingBookHandler(book)
    }
    
    func selectedNewBook(with book: CompleteBook) {
        selectedNewBookHandler(book)
    }
    
    func chart() {
        chartHandler()
    }
}
