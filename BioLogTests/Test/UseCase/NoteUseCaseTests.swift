//
//  NoteUseCaseTests.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/17/25.
//

import Foundation
import XCTest

import RxTest
import RxSwift
import RxCocoa

@testable import BioLog

class NoteUseCaseTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    var sut: NoteUseCaseImpl!
    var mockNoteRepository: MockNoteRepositoryImpl!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockNoteRepository = MockNoteRepositoryImpl()
        sut = NoteUseCaseImpl(repository: mockNoteRepository)
    }
    
    override func tearDown() {
        disposeBag = nil
        scheduler = nil
        sut = nil
        mockNoteRepository = nil
    }
    
    func test_successful_response() {
        let noteDummy = NoteDummy.savedNotes.first!
        
        let bookDummy = CharacterDTO.empty
        
        let observer = scheduler.createObserver(NoteDTO.self)
        
        mockNoteRepository.stubbedAddResult = .just(noteDummy)
        sut.add(with: noteDummy, character: bookDummy)
            .asObservable()
            .subscribe(on: MainScheduler.instance)
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertTrue(mockNoteRepository.isCalled, "함수가 불리지 않음")
        XCTAssertEqual(mockNoteRepository.lastCalledBook, bookDummy, "호출에 사용한 책과 동일하지 않음")
        XCTAssertEqual(mockNoteRepository.lastCalledNote, noteDummy, "호출에 사용한 노트과 동일하지 않음")
        
        XCTAssertEqual(observer.events, [
            .next(0, noteDummy),
            .completed(0)
        ])
    }
    
    func test_isbn으로_책을_검색했을때() {
        let searchedIsbn: String = "1234567890"
        let dummy = NoteDummy.savedNotes
        
        let observer = scheduler.createObserver([NoteDTO].self)
        
        mockNoteRepository.stubbedSavedResult = .just(dummy)
        sut.execute(isbn: searchedIsbn)
            .asObservable()
            .subscribe(on: MainScheduler.instance)
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertTrue(mockNoteRepository.isCalled, "함수가 불리지 않음")
        XCTAssertEqual(mockNoteRepository.lastCalledIsbn, searchedIsbn, "호출에 사용한 값과 동일하지 않음")
        
        XCTAssertEqual(observer.events, [
            .next(0, dummy),
            .completed(0)
        ])
    }
    
    func test_모든_노트를_가져올때() {
        let dummyNotes = NoteDummy.savedNotes
        let observer = scheduler.createObserver([NoteDTO].self)
        
        mockNoteRepository.stubbedSavedResult = .just(dummyNotes)
        
        sut.fetchAllNotes()
            .asObservable()
            .subscribe(on: MainScheduler.instance)
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertTrue(mockNoteRepository.isCalled, "함수가 불리지 않음")
        XCTAssertEqual(observer.events, [
            .next(0, dummyNotes),
            .completed(0)
        ])
    }
    
    func test_노트를_저장할때() {
        let noteToSave = NoteDummy.savedNotes.first!
        let result = NoteDummy.savedNotes.last!
        let observer = scheduler.createObserver(Void.self)
        
        mockNoteRepository.stubbedSavedResult = .just([result])
        
        sut.updateNote(with: noteToSave)
            .asObservable()
            .subscribe(on: MainScheduler.instance)
            .subscribe(
                onError: { error in observer.on(.error(error)) },
                onCompleted: { observer.on(.completed) }
            ).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertTrue(mockNoteRepository.isCalled, "함수가 불리지 않음")
        XCTAssertEqual(mockNoteRepository.lastCalledNote, noteToSave, "호출에 사용한 값과 동일하지 않음")
        XCTAssertTrue(observer.events[0].value.isCompleted, "완료 이벤트가 발생하지 않음")
    }
}
