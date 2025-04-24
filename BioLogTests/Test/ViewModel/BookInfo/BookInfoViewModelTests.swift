//
//  BookInfoViewModelTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/22/25.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import BioLog

final class BookInfoViewModelTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var mockBookUseCase: MockBookUseCaseImpl!
    var mockCharacterUseCase: MockCharacterUseCaseImpl!
    var mockNoteUseCase: MockNoteUseCase!
    var actionSpy: BookInfoActionSpy!
    var sut: BookInfoViewModel!
    var completeBook: CompleteBook!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag             = DisposeBag()
        mockBookUseCase        = MockBookUseCaseImpl()
        mockCharacterUseCase   = MockCharacterUseCaseImpl()
        mockNoteUseCase        = MockNoteUseCase()
        actionSpy              = BookInfoActionSpy()
        
        completeBook = CompleteBook(
            detail: BookDummy.savedBooks.first!,
            category: CategoryDummy.savedCategories.first!,
            characters: []
        )
        sut = BookInfoViewModel(
            book: completeBook,
            bookUseCase: mockBookUseCase,
            characterUseCase: mockCharacterUseCase,
            noteUseCase: mockNoteUseCase,
            actions: actionSpy
        )
    }
    
    func test() {
        let dummy = CharacterDummy.saveDummy.first!
        
        sut.selectedCharacter.onNext(dummy)
        
        //        XCTAssertTrue(mockCharacterUseCase.isCalled)
        //        XCTAssertEqual(mockCharacterUseCase.lastCalledCharacter, dummy)
        XCTAssertEqual(actionSpy.callHistory, [.pushCharacter(dummy)])
        XCTAssertEqual(actionSpy.passedCharacter, dummy)
    }
    
    func testaasdasd() {
        let observer = scheduler.createObserver([InfoSection].self)
        let dummy = CharacterDummy.saveDummy
        
        mockCharacterUseCase.stubbedAllCategories = .just(dummy)
        
        sut.viewWillAppear.onNext(())
        
        sut.result
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expect = [
            InfoSection(
                title: "Book Info",
                types: [.bookInfo(completeBook)]
            ),
            InfoSection(
                title: "Characters",
                types: dummy.map { .characters($0) } + [.characters(.empty)]
            )
        ]
        
        XCTAssertEqual(observer.events, [
            .next(0, expect)
        ])
    }
    
    func testa() {
        let dummy = CharacterDummy.saveDummy.first!
        
        //        sut.
        
        sut.viewWillAppear.onNext(())
        
        XCTAssertTrue(mockCharacterUseCase.isCalled)
        XCTAssertEqual(mockCharacterUseCase.lastCalledISBN, completeBook.detail.isbn)
    }
    
    func test_delete() {
        sut.delete.onNext(())
        
        XCTAssertTrue(mockBookUseCase.isCalled)
        XCTAssertEqual(actionSpy.callHistory, [.pop])
    }
    
    //    func test_viewWillAppear_fetchesCharacters_and_emitsInResult() throws {
    //        // given
    //        let chars = [ CharacterDTO(age: "10", name: "Alice", sex: "F", labor: "Hero") ]
    //        mockCharacterUseCase.stubbedExecuteResult = Single.just(chars)
    //
    //        // when: tap viewWillAppear
    //        vm.viewWillAppear.onNext(())
    //
    //        // then: result Driver emits a section containing our characters + an empty placeholder
    //        let sections = try vm.result
    //            .asObservable()
    //            .skip(1)                       // skip initial emission
    //            .toBlocking(timeout: 1)
    //            .first()!
    //
    //        let charSection = sections[1]
    //        XCTAssertEqual(charSection.title, "Characters")
    //
    //        // Expect the fetched characters first, then the empty placeholder
    //        let types = charSection.types
    //        guard case .characters(let first) = types[0] else { XCTFail(); return }
    //        XCTAssertEqual(first.name, "Alice")
    //        guard case .characters(let placeholder) = types.last else { XCTFail(); return }
    //        XCTAssertEqual(placeholder, .empty)
    //    }
    
    func test_delete_성공시_pop호출되는지() {
        mockBookUseCase.isFailed = false
        // when
        sut.delete.onNext(())
        // then
        XCTAssertTrue(mockBookUseCase.isCalled)
        XCTAssertEqual(actionSpy.callHistory, [.pop])
    }
    
    func test_delete_실패시_pop호출되지않는지() {
        // given
        mockBookUseCase.isFailed = true
        // when
        sut.delete.onNext(())
        // then
        XCTAssertTrue(actionSpy.callHistory.isEmpty)
    }
    
    //        func test_addCharacter_성공시_characters리스트에추가되는지() throws {
    //            // given
    //            let newChar = CharacterDTO(age: "30", name: "Zoe", sex: "F", uuid: UUID().uuidString, labor: "Artist", image: nil, createdAt: Date(), notes: [], original: nil)
    //            mockCharacterUseCase.stubbedAddResult = Single.just(newChar)
    //
    //            // observe result
    //            let sectionsBefore = try sut.result
    //                .asObservable()
    //                .skip(1)                   // skip initial emission
    //                .toBlocking(timeout: 2)
    //                .first()!
    //            // initial characters section has only the empty placeholder
    //            XCTAssertEqual(sectionsBefore[1].types, [.characters(.empty)])
    //
    //            // when
    //            sut.addCharacter.onNext(())
    //
    //            // then: a new emission appears with newChar + placeholder
    //            let sectionsAfter = try sut.result
    //                .asObservable()
    //                .skip(2)                   // skip initial + before
    //                .toBlocking(timeout: 1)
    //                .first()!
    //            let types = sectionsAfter[1].types
    //            XCTAssertEqual(types, [.characters(newChar), .characters(.empty)])
    //        }
    
    //        func test_addCharacter_실패시_characters변경없음() throws {
    //            // given
    //            mockCharacterUseCase.stubbedAddResult = .just(CharacterDummy.saveDummy.first!)
    //
    //            // when
    //            sut.addCharacter.onNext(())
    //
    //            // then: only initial placeholder remains
    //            let sections = try sut.result
    //                .asObservable()
    //                .skip(1)
    //                .toBlocking(timeout: 2)
    //                .first()!
    //            XCTAssertEqual(sections[1].types, [.characters(.empty)])
    //            // and no pop or push action
    //            XCTAssertTrue(actionSpy.callHistory.isEmpty)
    //        }
    
}
