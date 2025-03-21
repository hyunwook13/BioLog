//
//  BookUseCaseTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/7/25.
//

import Foundation
import XCTest

import RxSwift
import RxCocoa
import RxTest

@testable import BioLog

class BookUseCaseTests: XCTestCase {
    
    var sut: BookUseCaseImpl!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var mockBookRepository: MockBookRepositoryImpl!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockBookRepository = MockBookRepositoryImpl()
        sut = BookUseCaseImpl(repo: mockBookRepository)
    }
    
    func test_신규도서_패칭_테스트() {
        
        // given
        let dummyBooks: [BookDTO] = BookDummy.testBooks
        
        mockBookRepository.stubbedNewResult = .just(dummyBooks)
        
        // when
        let observer = scheduler.createObserver([BookDTO].self)
        
        sut.fetchNewBooks()
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // then
        XCTAssertTrue(mockBookRepository.isCalled)
        
        // 이벤트 확인
        let events = observer.events
        let nextEvents = events.compactMap { $0.value.element }
        XCTAssertEqual(nextEvents.count, 1, "이벤트가 정확히 하나 발생해야 합니다")
        
        // 결과 데이터 확인
        guard let result = events.first?.value.element else {
            return XCTFail("결과 데이터가 없습니다")
        }
        
        XCTAssertEqual(result.count, 3, "결과 배열의 길이가 3이어야 합니다")
        XCTAssertEqual(result[0].title, "테스트 책 1")
        XCTAssertEqual(result[1].title, "테스트 책 2")
        XCTAssertEqual(result[2].title, "테스트 책 3")
    }
    
    func test_읽고있는책_조회시_캐시가_없으면_레포지토리에서_가져오고_캐시를_갱신한다() {
        
        // given
        mockBookRepository.stubbedSaveResult = .just(BookDummy.savedBooks)
        
        // when
        let observer = scheduler.createObserver([BookDTO].self)
        
        sut.fetchReadingBooks()
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // then
        XCTAssertTrue(mockBookRepository.isCalled)
        
        // 이벤트 확인
        let events = observer.events
        let nextEvents = events.compactMap { $0.value.element }
        XCTAssertEqual(nextEvents.count, 1, "이벤트가 정확히 하나 발생해야 합니다")
        
        // 결과 데이터 확인
        guard let result = events.first?.value.element else {
            return XCTFail("결과 데이터가 없습니다")
        }
        
        XCTAssertEqual(result.count, 3, "결과 배열의 길이가 3이어야 합니다")
        XCTAssertEqual(result[0].title, "저장된 책 1")
        XCTAssertEqual(result[1].title, "저장된 책 2")
        XCTAssertEqual(result[2].title, "저장된 책 3")
    }
    
    func test_읽고있는책_조회시_캐시가_존재하면_레포지토리호출없이_캐시를반환한다() {
        // given
        sut.setCachedReadingBooks(BookDummy.cachedBooks) // 내부 테스트용 공개 API 또는 fileprivate 확장 사용
        
        // when
        let observer = scheduler.createObserver([BookDTO].self)
        sut.fetchReadingBooks()
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        scheduler.start()
        
        // then
        XCTAssertFalse(mockBookRepository.isCalled)
        
        // 이벤트 확인
        let events = observer.events
        let nextEvents = events.compactMap { $0.value.element }
        XCTAssertEqual(nextEvents.count, 1, "이벤트가 정확히 하나 발생해야 합니다")
        
        // 결과 데이터 확인
        guard let result = events.first?.value.element else {
            return XCTFail("결과 데이터가 없습니다")
        }
        
        XCTAssertEqual(result.count, 3, "결과 배열의 길이가 3이어야 합니다")
        XCTAssertEqual(result[0].title, "캐시 책 1")
        XCTAssertEqual(result[1].title, "캐시 책 2")
        XCTAssertEqual(result[2].title, "캐시 책 3")
    }
    
    func test_온라인에_책을_검색하면_결과를_반환한다() {
        
        // given
        let searchTitle = "검색한 책 제목"
        mockBookRepository.stubbedSearchResult = .just(BookDummy.searchedBooks)
        
        // when
        let observer = scheduler.createObserver([BookDTO].self)
        
        sut.searchBooksFromNetwork(with: searchTitle)
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // then
        XCTAssertTrue(mockBookRepository.isCalled)
        XCTAssertEqual(mockBookRepository.lastSearchedTitleWithNetwork, searchTitle)
        
        XCTAssertEqual(observer.events, [
            .next(0, BookDummy.searchedBooks),
            .completed(0)
        ])
    }
    
    func test_선택된책_저장을_하면_저장_성공한_객체를_반환한다() {
        let dummyData = BookDummy.sampleBooks.first!
        
        let observer = scheduler.createObserver(BookDTO.self)
        
        sut.save(with: dummyData)
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertTrue(mockBookRepository.isCalled)
        XCTAssertEqual(observer.events, [
            .next(0, dummyData),
            .completed(0)
        ])
    }
    
    func test_책을_삭제하면_저장소에서_삭제된다() {
        // given
        let bookToDelete = BookDummy.sampleBooks.first!
        
        // when
        let observer = scheduler.createObserver(Void.self)

        sut.delete(with: bookToDelete)
            .subscribe(
                onCompleted: { observer.on(.completed) },
                onError: { error in observer.on(.error(error)) }
            )
            .disposed(by: disposeBag)

        scheduler.start()
        
        // then
        XCTAssertTrue(mockBookRepository.isCalled)
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertTrue(observer.events[0].value.isCompleted)
    }
    
    func test_저장된_책을_검색하여_결과를_반환한다() {
        let searchedTitle = "검색 결과 책"
        let BookDummy = BookDummy.searchedBooks
        sut.setCachedReadingBooks(BookDummy)
        
        let observer = scheduler.createObserver([BookDTO].self)
        
        sut.searchLocalBooks(with: searchedTitle)
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [
            .next(0, BookDummy),
            .completed(0)
        ])
    }
    
    func test_빈값_검색시_캐시된_책을_반환한다() {
        let BookDummy = BookDummy.cachedBooks
        sut.setCachedReadingBooks(BookDummy)
        
        let observer = scheduler.createObserver([BookDTO].self)
        
        sut.searchLocalBooks(with: "")
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [
            .next(0, BookDummy),
            .completed(0)
        ])
    }
    
    func test_신간도서를_잘받아오는지() {
        let BookDummy = BookDummy.newBooks
        mockBookRepository.stubbedNewResult = .just(BookDummy)
        
        let observer = scheduler.createObserver([BookDTO].self)
        
        sut.fetchNewBooks()
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertTrue(mockBookRepository.isCalled)
        XCTAssertEqual(observer.events, [
            .next(0, BookDummy),
            .completed(0)
        ])
    }
    
    func test_세그먼트_ALL_선택했을때_전체책을_가져온다() {
        let savedDummy = BookDummy.savedBooks
        let cachedDummy = BookDummy.cachedBooks
        
        sut.setCachedReadingBooks(savedDummy + cachedDummy)
        
        let observer = scheduler.createObserver([BookDTO].self)
        
        sut.fetchBooksBySegmentType(.all)
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [
            .next(0, savedDummy + cachedDummy),
            .completed(0)
        ])
    }
    
    func test_세그먼트_북마크_선택했을때_해당조건책을_가져온다() {
        let bookmarkDummy = BookDummy.bookmarkedBooks
        let cachedDummy = BookDummy.cachedBooks
        sut.setCachedReadingBooks(bookmarkDummy + cachedDummy)
        
        let observer = scheduler.createObserver([BookDTO].self)
        
        sut.fetchBooksBySegmentType(.bookmared)
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [
            .next(0, bookmarkDummy),
            .completed(0)
        ])
    }
    
    func test_세그먼트_읽고있는책_선택했을때_해당조건책을_가져온다() {
        let bookmarkDummy = BookDummy.bookmarkedBooks
        let cachedDummy = BookDummy.cachedBooks
        sut.setCachedReadingBooks(bookmarkDummy + cachedDummy)
        
        let observer = scheduler.createObserver([BookDTO].self)
        
        sut.fetchBooksBySegmentType(.reading)
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [
            .next(0, cachedDummy),
            .completed(0)
        ])
    }
}
