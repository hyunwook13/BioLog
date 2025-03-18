//  MainViewModelTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/7/25.

import XCTest
import RxSwift
import RxCocoa
import RxTest

@testable import BioLog

enum TestError: Error { case test }

class MainViewModelTests: XCTestCase {
    
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockBookUseCase: MockBookUseCaseImpl!
    var sut: MainViewModel!
    var spyMainAction: MainActionSpy!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockBookUseCase = MockBookUseCaseImpl()
        spyMainAction = MainActionSpy()
        sut = MainViewModel(usecase: mockBookUseCase, actions: spyMainAction)
        // MARK: - 추가 액션 테스트
        
        func test_SELECT_READING_BOOK_버튼을_눌렀을때_액션이_작동하는지() {
            // given
            let dummyBook = BookDummy.testBooks[1]
            let completeBook = CompleteBook(detail: dummyBook, category: .empty, characters: [])
            // when
            sut.selectReadingBook.onNext(completeBook)
            // then
            XCTAssertEqual(spyMainAction.passedCompleteBook, completeBook)
            XCTAssertEqual(spyMainAction.callHistory, [.selectedReadingBook(completeBook)])
        }
        
        func test_SELECT_READING_BOOK_연속_클릭시_하나만_동작하는지() {
            let dummyBook = BookDummy.testBooks[1]
            let completeBook = CompleteBook(detail: dummyBook, category: .empty, characters: [])
            // when
            sut.selectReadingBook.onNext(completeBook)
            sut.selectReadingBook.onNext(completeBook)
            scheduler.advanceTo(1000) // 1초
            // then
            XCTAssertEqual(spyMainAction.passedCompleteBook, completeBook)
            XCTAssertEqual(spyMainAction.callHistory.count, 1)
        }
        
        func test_chart_버튼을_눌렀을때_액션이_작동하는지() {
            // when
            sut.chart.onNext(())
            // then
            XCTAssertEqual(spyMainAction.callHistory, [.chart])
        }
    }
    
    func test_ADD_버튼을_눌렀을떄_액션이_작동하는지() {
        // when
        sut.add.onNext(())
        // then
        XCTAssertEqual(spyMainAction.callHistory, [.present])
    }
    
    func test_책_을_선택했을때_액션이_작동하는지() {
        // given
        let dummyBook = BookDummy.testBooks.first!
        let completeBook = CompleteBook(detail: dummyBook, category: .empty, characters: [])
        // when
        sut.selectNewBook.onNext(completeBook)
        // then
        XCTAssertEqual(spyMainAction.passedCompleteBook, completeBook)
        XCTAssertEqual(spyMainAction.callHistory, [.selectedNewBook(completeBook)])
    }
    
    func test_책_선택_연속_클릭시_하나만_동작하는지() {
        let dummyBook = BookDummy.testBooks.first!
        let completeBook = CompleteBook(detail: dummyBook, category: .empty, characters: [])
        // when
        sut.selectNewBook.onNext(completeBook)
        sut.selectNewBook.onNext(completeBook)
        scheduler.advanceTo(1000) // 1초
        // then
        XCTAssertEqual(spyMainAction.passedCompleteBook, completeBook)
        XCTAssertEqual(spyMainAction.callHistory.count, 1)
    }
    
    func test_viewWillAppear_시점에_데이터를_불러오는지() {
        // when
        sut.viewWillAppear.onNext(())
        // then
        XCTAssertTrue(mockBookUseCase.isCalled)
    }
    
    // MARK: - Driver Tests for readingBooks and newBooks
    
    func test_readingBooks_emitsMappedCompleteBooks_onSuccess() {
        // given
        let dto = BookDummy.savedBooks[0]
        mockBookUseCase.stubbedSaveResult = .just([dto])
        let expected = [CompleteBook(detail: dto, category: dto.category, characters: dto.characters)]
        
        // when
        let observer = scheduler.createObserver([CompleteBook].self)
        sut.readingBooks
            .drive(observer)
            .disposed(by: disposeBag)
        sut.viewWillAppear.onNext(())
        scheduler.start()
        
        // then
        XCTAssertEqual(observer.events, [
            .next(0, expected)
        ])
    }
    
    func test_readingBooks_emitsEmpty_onEmptyResult() {
        // given
        mockBookUseCase.stubbedSaveResult = .just([])
        
        // when
        let observer = scheduler.createObserver([CompleteBook].self)
        sut.readingBooks
            .drive(observer)
            .disposed(by: disposeBag)
        sut.viewWillAppear.onNext(())
        scheduler.start()
        
        // then
        XCTAssertEqual(observer.events, [
            .next(0, [])
        ])
    }
    
    func test_readingBooks_emitsEmpty_onError() {
        // given
        mockBookUseCase.stubbedSaveResult = .error(TestError.test)
        
        // when
        let observer = scheduler.createObserver([CompleteBook].self)
        sut.readingBooks
            .drive(observer)
            .disposed(by: disposeBag)
        sut.viewWillAppear.onNext(())
        scheduler.start()
        
        // then
        XCTAssertEqual(observer.events, [
            .next(0, [])
        ])
    }
    
    func test_newBooks_emitsMappedCompleteBooks_onSuccess() {
        // given
        let dto = BookDummy.newBooks[0]
        mockBookUseCase.stubbedNewResult = .just([dto])
        let expected = [CompleteBook(detail: dto, category: dto.category, characters: dto.characters)]
        
        // when
        let observer = scheduler.createObserver([CompleteBook].self)
        sut.newBooks
            .drive(observer)
            .disposed(by: disposeBag)
        sut.viewWillAppear.onNext(())
        scheduler.start()
        
        // then
        XCTAssertEqual(observer.events, [
            .next(0, expected)
        ])
    }
    
    func test_newBooks_emitsEmpty_onEmptyResult() {
        // given
        mockBookUseCase.stubbedNewResult = .just([])
        
        // when
        let observer = scheduler.createObserver([CompleteBook].self)
        sut.newBooks
            .drive(observer)
            .disposed(by: disposeBag)
        sut.viewWillAppear.onNext(())
        scheduler.start()
        
        // then
        XCTAssertEqual(observer.events, [
            .next(0, [])
        ])
    }
    
    func test_newBooks_emitsEmpty_onError() {
        // given
        mockBookUseCase.stubbedNewResult = .error(TestError.test)
        
        // when
        let observer = scheduler.createObserver([CompleteBook].self)
        sut.newBooks
            .drive(observer)
            .disposed(by: disposeBag)
        sut.viewWillAppear.onNext(())
        scheduler.start()
        
        // then
        XCTAssertEqual(observer.events, [
            .next(0, [])
        ])
    }
    
    func test_책_섹션_구성이_정상적으로_되는지() {
        // given
        mockBookUseCase.stubbedSaveResult = .just(BookDummy.savedBooks)
        mockBookUseCase.stubbedNewResult = .just(BookDummy.newBooks)
        // when
        let observer = scheduler.createObserver([Section].self)
        sut.book
            .drive(observer)
            .disposed(by: disposeBag)
        sut.viewWillAppear.onNext(())
        scheduler.start()
        
        // then
        let sections = observer.events.last?.value.element
        
        XCTAssertEqual(sections?.first?.title, "저장된 책")
        XCTAssertFalse(sections?.first?.items.isEmpty ?? true)
        XCTAssertEqual(sections?.last?.title, "따끈따끈 신간 도서")
        XCTAssertFalse(sections?.last?.items.isEmpty ?? true)
    }
}
