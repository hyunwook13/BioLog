//
//  CharacterUseCaseTests.swift
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

class CharacterUseCaseTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var repo: MockCharacterRepositoryImpl!
    var sut: CharactersUseCaseImpl!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        repo = MockCharacterRepositoryImpl()
        sut = CharactersUseCaseImpl(repo: repo)
    }
    
    func testExecuteSuccess() throws {
        let searched = "asdasd"
        let dummy = CharacterDummy.saveDummy
        repo.stubbedAllCategories = .just(dummy)
        
        let observer = scheduler.createObserver([CharacterDTO].self)
        
        sut.execute(isbn: searched)
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertTrue(repo.isCalled)
        XCTAssertEqual(searched, repo.lastCalledISBN)
        XCTAssertEqual(observer.events, [
            .next(0, dummy),
            .completed(0)
        ])
    }
    
    func testExecuteFailure() {
        let searched = "asdasd"
        let dummy = CharacterDummy.saveDummy
        repo.stubbedAllCategories = .just(dummy)
        repo.isFailed = true
        
        let observer = scheduler.createObserver([CharacterDTO].self)
        
        // When: 0시점에 구독 시작
        sut.execute(isbn: searched)
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        scheduler.start()
        
        // Then: repo 호출 확인
        XCTAssertTrue(repo.isCalled)
        XCTAssertEqual(searched, repo.lastCalledISBN)
        
        // 오류 이벤트가 기록됐는지 확인
        XCTAssertEqual(observer.events, [
            .error(0, TestError.test)
        ])
    }
    
    // add(with:book:)
    func testAddSuccess() throws {
        let addCharacter = CharacterDummy.saveDummy.first!
        let book = BookDummy.savedBooks.first!
        
        let testCharacter = CharacterDummy.saveDummy.last!
        repo.stubbedCategories = .just(testCharacter)
        
        let observer = scheduler.createObserver(CharacterDTO.self)
        
        sut.add(with: addCharacter, book: book)
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        XCTAssertTrue(repo.isCalled)
        XCTAssertEqual(repo.lastCalledBook, book)
        XCTAssertEqual(repo.lastCalledCharacter, addCharacter)
        XCTAssertEqual(observer.events, [
            .next(0, testCharacter),
            .completed(0)
        ])
    }
    
    func testAddFailure() {
        let addCharacter = CharacterDummy.saveDummy.first!
        let book = BookDummy.savedBooks.first!
        repo.isFailed = true
        
        let observer = scheduler.createObserver(CharacterDTO.self)
        
        sut.add(with: addCharacter, book: book)
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [
            .error(0, TestError.test)
        ])
    }
    //
    //    // updateCharacter(with:)
        func testUpdateSuccess() {
            let addCharacter = CharacterDummy.saveDummy.first!
            
            let observer = scheduler.createObserver(Void.self)
            
            sut.updateCharacter(with: addCharacter)
                .asObservable()
                .subscribe(on: MainScheduler.instance)
                .subscribe(
                    onError: { error in observer.on(.error(error)) },
                    onCompleted: { observer.on(.completed) }
                    ).disposed(by: disposeBag)
                     
            XCTAssertTrue(observer.events[0].value.isCompleted, "완료 이벤트가 발생하지 않음")
                    
            XCTAssertEqual(repo.lastCalledCharacter, addCharacter)
            XCTAssertTrue(repo.isCalled)
        }
    
        func testUpdateFailure() {
            let addCharacter = CharacterDummy.saveDummy.first!
            repo.isFailed = true
            
            let observer = scheduler.createObserver(Void.self)
            
            sut.updateCharacter(with: addCharacter)
                .asObservable()
                .subscribe(on: MainScheduler.instance)
                .subscribe(
                    onError: { error in observer.on(.error(error)) },
                    onCompleted: { observer.on(.completed) }
                    ).disposed(by: disposeBag)
                     
            let events = observer.events
            XCTAssertEqual(events.count, 1, "이벤트 개수가 1개여야 합니다")
            switch events[0].value.event {
            case .error(let error):
                XCTAssertEqual(error as! TestError, TestError.test)
            default:
                XCTFail("error 이벤트가 발생하지 않았습니다")
            }
                    
            XCTAssertEqual(repo.lastCalledCharacter, addCharacter)
            XCTAssertTrue(repo.isCalled)
        }
    
        func testFetchAllSuccess() throws {
            let characters = CharacterDummy.saveDummy
            repo.stubbedAllCategories = .just(characters)
            
            let observer = scheduler.createObserver([CharacterDTO].self)
            
            sut.fetchAllCharacter()
                .asObservable()
                .bind(to: observer)
                .disposed(by: disposeBag)
            
            XCTAssertEqual(observer.events, [
                .next(0, characters),
                .completed(0)
            ])
            
            XCTAssertTrue(repo.isCalled)
        }
    
    func testFetchAllFailure() throws {
        repo.isFailed = true
        let characters = CharacterDummy.saveDummy
        repo.stubbedAllCategories = .just(characters)
        
        let observer = scheduler.createObserver([CharacterDTO].self)
        
        sut.fetchAllCharacter()
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        XCTAssertEqual(observer.events, [
            .error(0, TestError.test)
        ])
        
        XCTAssertTrue(repo.isCalled)
    }
}

