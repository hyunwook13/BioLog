//
//  SearchBookViewModelTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/17/25.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
import RxTest

@testable import BioLog

final class SearchBookViewModelTests: XCTestCase {
    
    var sut: SearchBookViewModel!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var mockCategoryUseCase: MockCategoryUseCaseImpl!
    var mockBookUseCase: MockBookUseCaseImpl!
    var actionSpy: SearchBookActionSpy!
    
    override func setUp() {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
        mockCategoryUseCase = MockCategoryUseCaseImpl()
        mockBookUseCase = MockBookUseCaseImpl()
        actionSpy = SearchBookActionSpy()
        sut = SearchBookViewModel(categoryUseCase: mockCategoryUseCase, bookUseCase: mockBookUseCase, action: actionSpy, scheduler: scheduler)
    }
    
    //    override func tearDown() {
    //        disposeBag = nil
    //        scheduler = nil
    //        mockCategoryUseCase = nil
    //        mockBookUseCase = nil
    //        actionSpy = nil
    //        sut = nil
    //    }
    
    func test_취소_트리거시_cancel액션이_호출되는지() {
        // when
        sut.cancel.onNext(())
        // then
        XCTAssertEqual(actionSpy.callHistory.last, .cancel)
    }
    
    func test_책_선택시_selected_액션과_완료된책이_전달되는지() {
        // given
        let dummy = BookDummy.savedBooks.first!
        let completeBook = CompleteBook(detail: dummy, category: .empty, characters: [])
        // when
        sut.selectedBook.onNext(dummy)
        // then
        XCTAssertEqual(actionSpy.callHistory.last, .selected(completeBook))
        XCTAssertEqual(actionSpy.passedCompleteBook, completeBook)
    }
    
    //    func test_books_debounce_only() {
    //        let isPlaying = scheduler.createObserver([BookDTO].self)
    //
    //        sut.books
    //          .drive(isPlaying)
    //          .disposed(by: disposeBag)
    //
    //        sut.searchedTitle.onNext("One")
    //        scheduler.advanceTo(100)
    //
    //
    ////        sut.searchedTitle.onNext("Two")
    ////        scheduler.advanceTo(200)
    ////
    ////        sut.searchedTitle.onNext("Three")
    ////        scheduler.advanceTo(300)
    //
    //
    //        XCTAssertEqual(isPlaying.events, [
    //          .next(400, [])
    //        ])
    //        // then
    //        XCTAssertEqual(mockBookUseCase.callCount, 1)
    //        XCTAssertEqual(mockBookUseCase.lastSearchedTitleWithNetwork, "Three")
    //    }
    
    // MARK: - SearchBookViewModel DistinctUntilChanged Tests
    func test_books_distinctUntilChanged_only() {
        // given
        mockBookUseCase.callCount = 0
        mockBookUseCase.stubbedSearchResult = .just([])
        
        // when: same input, spaced beyond debounce
        scheduler.scheduleAt(100) { self.sut.searchedTitle.onNext("Repeat") }
        scheduler.advanceTo(500)  // first debounce fires at 100+300
        scheduler.scheduleAt(600) { self.sut.searchedTitle.onNext("Repeat") }
        scheduler.advanceTo(1000) // second debounce would fire at 600+300
        
        // then
        XCTAssertEqual(mockBookUseCase.callCount, 1)
        XCTAssertEqual(mockBookUseCase.lastSearchedTitleWithNetwork, "Repeat")
    }
    
    
    func test_books_emitsResults_onSuccess() {
        // given
        let dto = [BookDummy.testBooks.first!]
        mockBookUseCase.stubbedSearchResult = .just(dto)
        
        let observer = scheduler.createObserver([BookDTO].self)
        
        //        scheduler.scheduleAt(0) {
        /*self.*/
        sut.books
            .asObservable()
            .subscribe(observer)
            .disposed(by: self.disposeBag)
        //        }
        //
        //        sut.books
        //            .drive(observer)
        //            .disposed(by: disposeBag)
        //
        // when
        scheduler.scheduleAt(0) {
            self.sut.searchedTitle.onNext("Query")
        }
        // 300ms debounce + scheduling
        scheduler.start()
        
        // then
        XCTAssertTrue(mockBookUseCase.isCalled)
        XCTAssertEqual(mockBookUseCase.lastSearchedTitleWithNetwork, "Query")
        XCTAssertEqual(observer.events, [
            .next(0, dto)
        ])
        
        //        mockBookUseCase.stubbedNewResult = .just([])
        //
        //        // when
        //        let observer = scheduler.createObserver([CompleteBook].self)
        //        sut.newBooks
        //            .drive(observer)
        //            .disposed(by: disposeBag)
        //        sut.viewWillAppear.onNext(())
        //        scheduler.start()
        //
        //        // then
        //        XCTAssertEqual(observer.events, [
        //            .next(0, [])
        //        ])
    }
    
    //    func test_books_emitsEmpty_onEmptyResult() {
    //        // given
    //        mockBookUseCase.stubbedSearchResult = Single.just([])
    //
    //        let observer = scheduler.createObserver([BookDTO].self)
    //
    //        scheduler.scheduleAt(0) {
    //          self.sut.books
    //            .asObservable()
    //            .subscribe(observer)
    //            .disposed(by: self.disposeBag)
    //        }
    ////        sut.books
    ////            .drive(observer)
    ////            .disposed(by: disposeBag)
    //
    //        // when
    //        sut.searchedTitle.onNext("Nothing")
    //
    //        // then
    //        XCTAssertEqual(observer.events, [
    //            .next(0, [])
    //        ])
    //
    //    }
    //
    //    func test_books_emitsEmpty_onError() {
    ////        // given
    ////        mockBookUseCase.stubbedSearchResult = Single.error(TestError.test)
    ////
    ////        let observer = scheduler.createObserver([BookDTO].self)
    ////        scheduler.scheduleAt(0) {
    ////          self.sut.books
    ////            .asObservable()
    ////            .subscribe(observer)
    ////            .disposed(by: self.disposeBag)
    ////        }
    ////
    ////        // when
    ////        sut.searchedTitle.onNext("Error")
    ////
    ////
    ////
    ////        // then
    ////        XCTAssertEqual(observer.events, [
    ////            .next(0, [])
    ////        ])
    //
    //        // 1) 구독 준비
    //        let observer = scheduler.createObserver([BookDTO].self)
    //
    ////        scheduler.scheduleAt(5) {
    ////            self.sut.books
    ////                .skip(1)
    ////                .asObservable()
    ////                .subscribe(observer)
    ////                .disposed(by: self.disposeBag)
    ////        }
    //
    //
    //
    //        // 2) 검색어 발행 스케줄링
    //        scheduler.scheduleAt(210) {
    //            self.sut.searchedTitle.onNext("Error")
    //        }
    //
    //        // 3) 가상 시간 전진: debounce 기간(300ms)을 넘어가도록
    //        scheduler.advanceTo(510)
    //
    //        scheduler.start(created: 0, subscribed: 1, disposed: 900) {
    //            self.sut.books
    ////                .skip(1)
    //                .asObservable()
    //                .subscribe(observer)
    //                .disposed(by: self.disposeBag)
    //        }
    //
    ////        observer.events.assert
    //        // 4) 결과 검증
    //        XCTAssertEqual(observer.events, [
    //            .next(510, [])    // 10 + debounce 300 = 310 시점에 방출
    //        ])
    //    }
    //}
    
}
