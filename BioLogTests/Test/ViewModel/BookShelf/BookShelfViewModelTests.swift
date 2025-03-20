//
//  BookShelfViewModelTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 3/26/25.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import BioLog

class BookShelfViewModelTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockBookUseCase: MockBookUseCaseImpl!
    var sut: BookShelfViewModel!
    var actionSpy: BookShelfActionSpy!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockBookUseCase = MockBookUseCaseImpl()
        actionSpy = BookShelfActionSpy()
        sut = BookShelfViewModel(usecase: mockBookUseCase, action: actionSpy)
    }
    
    func test_검색타이틀입력시_검색결과전달되고_UseCase호출됨() {
        let searchedTitle = "검색한 타이틀"
        mockBookUseCase.stubbedSearchResult = .just(BookDummy.searchedBooks)
        
        let observer = scheduler.createObserver([BookDTO].self)
        
        sut.searchedBook
            .drive(observer)
            .disposed(by: disposeBag)
        
        sut.searchBookTitle.onNext(searchedTitle)
        
        scheduler.start()
        
        XCTAssertTrue(mockBookUseCase.isCalled)
        XCTAssertEqual(mockBookUseCase.lastSearchedTitleWithLocal, searchedTitle)
        XCTAssertEqual(observer.events, [
            .next(0, BookDummy.searchedBooks)
        ])
    }
    
    
    func test_searchLocalBooks_emitsEmptyArray_onEmptyResult() {
        // given
        mockBookUseCase.stubbedSearchResult = .just([])

        let observer = scheduler.createObserver([BookDTO].self)
        scheduler.scheduleAt(0) {
            self.sut.searchedBook
                .asObservable()
                .subscribe(observer)
                .disposed(by: self.disposeBag)
        }

        // when
        scheduler.scheduleAt(100) {
            self.sut.searchBookTitle.onNext("Nothing")
        }
        scheduler.advanceTo(200)

        // then
        XCTAssertEqual(observer.events, [
            .next(100, [])
        ])
    }

    func test_searchLocalBooks_emitsNoEvent_onError() {
        // given
        mockBookUseCase.stubbedSearchResult = .error(TestError.test)

        let observer = scheduler.createObserver([BookDTO].self)
        scheduler.scheduleAt(0) {
            self.sut.searchedBook
                .asObservable()
                .subscribe(observer)
                .disposed(by: self.disposeBag)
        }

        // when
        scheduler.scheduleAt(100) {
            self.sut.searchBookTitle.onNext("ErrorCase")
        }
        scheduler.advanceTo(200)

        // then
        XCTAssertTrue(observer.events.isEmpty)
    }
    
    func test_책선택시_책정보와함께_push이벤트_발생함() { 
        let dummy = BookDummy.savedBooks.first!
        
        sut.selectedBook.onNext(dummy)
            
        XCTAssertEqual(actionSpy.callHistory, [.pushWithBook(dummy)])
        XCTAssertEqual(actionSpy.passedBook, dummy)
    }
    
    // BookShelfViewModelTests.swift
    func test_인덱스0_선택시_모든도서_호출되는지() {
        // given
        let dummy = BookDummy.searchedBooks
        mockBookUseCase.stubbedSearchResult = .just(dummy)
        mockBookUseCase.stubbedSaveResult   = .just([])
        mockBookUseCase.stubbedNewResult    = .just([])

        let observer = scheduler.createObserver([BookDTO].self)
        scheduler.scheduleAt(0) {
            self.sut.searchedBook
                .asObservable()
                .subscribe(observer)
                .disposed(by: self.disposeBag)
        }

        // when
        scheduler.scheduleAt(10) { self.sut.selectedIndex.onNext(0) }
        scheduler.advanceTo(20)

        // then
        XCTAssertEqual(mockBookUseCase.lastRequestedType, .all)
        XCTAssertEqual(observer.events, [
            .next(10, dummy)
        ])
    }

    func test_인덱스1_선택시_읽는중도서_호출되는지() {
        // given
        let saved = BookDummy.savedBooks
        mockBookUseCase.stubbedSaveResult   = .just(saved)
        mockBookUseCase.stubbedSearchResult = .just([])
        mockBookUseCase.stubbedNewResult    = .just([])

        let observer = scheduler.createObserver([BookDTO].self)
        scheduler.scheduleAt(0) {
            self.sut.searchedBook
                .asObservable()
                .subscribe(observer)
                .disposed(by: self.disposeBag)
        }

        // when
        scheduler.scheduleAt(10) { self.sut.selectedIndex.onNext(1) }
        scheduler.advanceTo(20)

        // then
        XCTAssertEqual(mockBookUseCase.lastRequestedType, .reading)
        XCTAssertEqual(observer.events, [
            .next(10, saved)
        ])
    }

    func test_인덱스2_선택시_북마크도서_호출되는지() {
        // given
        let bookmarked = BookDummy.newBooks
        mockBookUseCase.stubbedNewResult    = .just(bookmarked)
        mockBookUseCase.stubbedSearchResult = .just([])
        mockBookUseCase.stubbedSaveResult   = .just([])

        let observer = scheduler.createObserver([BookDTO].self)
        scheduler.scheduleAt(0) {
            self.sut.searchedBook
                .asObservable()
                .subscribe(observer)
                .disposed(by: self.disposeBag)
        }

        // when
        scheduler.scheduleAt(10) { self.sut.selectedIndex.onNext(2) }
        scheduler.advanceTo(20)

        // then
        XCTAssertEqual(mockBookUseCase.lastRequestedType, .bookmared)
        XCTAssertEqual(observer.events, [
            .next(10, bookmarked)
        ])
    }
}
