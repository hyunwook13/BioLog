//
//  MockBookUseCaseImpl.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/7/25.
//

import Foundation
import RxSwift
import RxCocoa

@testable import BioLog

class MockBookUseCaseImpl: BookUseCase {
    
    var isFailed = false
    var isCalled = false
    var lastSearchedTitleWithNetwork: String!
    var lastSearchedTitleWithLocal: String!
    var callCount: Int = 0
    var lastRequestedType: BookShelfType?
    
    var stubbedSearchResult: Single<[BookDTO]> = .just([]) // 기본값
    var stubbedSaveResult: Single<[BookDTO]> = .just([]) // 기본값
    var stubbedNewResult: Single<[BookDTO]> = .just([]) // 기본값
    
    func save(with book: BioLog.BookDTO) -> RxSwift.Single<BioLog.BookDTO> {
        isCalled = true
        return Observable.just(book).asSingle()
    }
    
    func searchBooksFromNetwork(with title: String) -> RxSwift.Single<[BioLog.BookDTO]> {
        print("들어옴")
        print("title", title)
        callCount += 1
        isCalled = true
        lastSearchedTitleWithNetwork = title
        
        return stubbedSearchResult
    }
    
    func searchLocalBooks(with title: String) -> RxSwift.Single<[BioLog.BookDTO]> {
        isCalled = true
        self.lastSearchedTitleWithLocal = title
        return stubbedSearchResult
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
        
        if isFailed {
            return .error(TestError.test)
        } else {
            return .empty()
        }
    }
    
    func fetchBooksBySegmentType(_ type: BookShelfType) -> Single<[BookDTO]> {
        isCalled = true
        lastRequestedType = type              // 호출된 타입을 기록
        switch type {
        case .all:       return stubbedSearchResult
        case .bookmared: return stubbedNewResult
        case .reading:   return stubbedSaveResult
        }
    }
}
