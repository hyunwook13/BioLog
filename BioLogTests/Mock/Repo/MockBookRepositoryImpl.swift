//
//  MockBookRepositoryImpl.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/7/25.
//

import Foundation

import RxSwift
import RxCocoa

@testable import BioLog

class MockBookRepositoryImpl: BookRepository {
    
    var isCalled = false
    var lastSearchedTitleWithNetwork: String!
    var lastCalledBook: BookDTO!
    var stubbedDeleteResult: Single<[BookDTO]> = .just([]) // 기본값
    var stubbedSearchResult: Single<[BookDTO]> = .just([]) // 기본값
    var stubbedSaveResult: Single<[BookDTO]> = .just([]) // 기본값
    var stubbedNewResult: Single<[BookDTO]> = .just([]) // 기본값
    
    var currentBook = RxRelay.BehaviorRelay<[BioLog.BookDTO]>(value: [])
    
    func findBooks(byTitle title: String) -> RxSwift.Single<[BioLog.BookDTO]> {
        isCalled = true
        lastSearchedTitleWithNetwork = title
        return stubbedSearchResult
    }
    
    func save(with book: BioLog.BookDTO) -> RxSwift.Observable<BioLog.BookDTO> {
        isCalled = true
        lastCalledBook = book
        return Observable.of(book)
    }
    
    func fetchNewBooks() -> RxSwift.Single<[BioLog.BookDTO]> {
        isCalled = true
        return stubbedNewResult
    }
    
    func fetchReadingBooks() -> RxSwift.Single<[BioLog.BookDTO]> {
        isCalled = true
        return stubbedSaveResult
    }
    
    func delete(with book: BioLog.BookDTO) -> RxSwift.Completable {
        isCalled = true
        lastCalledBook = book
        return Completable.empty()
    }
}
