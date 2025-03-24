//
//  MockCharacterUseCaseImpl.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/22/25.
//

import Foundation
import RxSwift
import RxCocoa

@testable import BioLog

class MockCharacterUseCaseImpl: CharactersUseCase {
    
    var isCalled = false
    var isFailed: Bool = false
    var lastCalledISBN: String?
    var lastCalledCharacter: CharacterDTO?
    var lastCalledBook: BookDTO?
    
    var stubbedCharacter: Single<BioLog.CharacterDTO> = .just(.empty)
    var stubbedAllCategories: Single<[BioLog.CharacterDTO]> = .just([])
    var stubbedAddResult: Single<BioLog.CharacterDTO> = .just(.empty)
    
    func execute(isbn: String) -> RxSwift.Single<[BioLog.CharacterDTO]> {
        isCalled = true
        lastCalledISBN = isbn
        
        if isFailed {
            return .error(TestError.test)
        } else {
            return stubbedAllCategories
        }
    }
    
    func add(with dto: BioLog.CharacterDTO, book: BioLog.BookDTO) -> RxSwift.Single<BioLog.CharacterDTO> {
        isCalled = true
        lastCalledBook = book
        lastCalledCharacter = dto
        
        if isFailed {
            return .error(TestError.test)
        } else {
            return stubbedAddResult
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
