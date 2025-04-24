//
//  MockCharacterRepositoryImpl.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/22/25.
//


import Foundation
import XCTest

import RxSwift
import RxCocoa
import RxTest

@testable import BioLog

class MockCharacterRepositoryImpl: CharacterRepository {
    var isCalled = false
    var isFailed = false
    var lastCalledISBN: String!
    var lastCalledCharacter: CharacterDTO!
    var lastCalledBook: BookDTO!
    var stubbedCategories: Single<BioLog.CharacterDTO> = .just(.empty)
    var stubbedAllCategories: Single<[BioLog.CharacterDTO]> = .just([])
    
    func create(book: BioLog.BookDTO, character: BioLog.CharacterDTO) -> RxSwift.Observable<BioLog.CharacterDTO> {
        isCalled = true
        lastCalledBook = book
        lastCalledCharacter = character
        
        if isFailed {
            return .error(TestError.test)
        } else {
            return stubbedCategories.asObservable()
        }
    }
    
    func fetch(by id: String) -> RxSwift.Single<[BioLog.CharacterDTO]> {
        isCalled = true
        lastCalledISBN = id
        
        if isFailed {
            return .error(TestError.test)
        } else {
            return stubbedAllCategories
        }
    }
    
    func updateCharacter(with dto: BioLog.CharacterDTO) -> RxSwift.Completable {
        isCalled = true
        lastCalledCharacter = dto
        
        if isFailed {
            return .error(TestError.test)
        } else {
            return .empty()
        }
    }
    
    func fetchAllCharacter() -> RxSwift.Single<[BioLog.CharacterDTO]> {
        isCalled = true
        
        if isFailed {
            return .error(TestError.test)
        } else {
            return stubbedAllCategories
        }
    }
}
