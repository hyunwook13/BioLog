//
//  MockNoteUseCaseImpl.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/21/25.
//

import Foundation
import RxSwift
import RxCocoa

@testable import BioLog

class MockNoteUseCase: NoteUseCase {
    
    // MARK: — updateNote
    var isFailed = false
    var isCalled = false
    var updateCallCount = 0
    var lastNoteDTO: NoteDTO?
    var lastCharacterDTO: CharacterDTO?
    var lastISBN: String?
    var stubbedUpdateResult: Completable = .empty()
    var stubbedExecuteResult: Single<[NoteDTO]> = .just([])
    var stubbedAddResult: Single<NoteDTO> = .just(
        NoteDTO(context: "", page: "", uuid: UUID().uuidString)
    )
    
    func updateNote(with dto: NoteDTO) -> Completable {
        isCalled = true
        lastNoteDTO = dto
        updateCallCount += 1
        
        print("udpate 불림", isFailed)
        
        if isFailed {
            return .error(TestError.test)
        } else {
            return stubbedUpdateResult
        }
    }
    
    func execute(isbn: String) -> Single<[NoteDTO]> {
        isCalled = true
        lastISBN = isbn
        
        if isFailed {
            return .error(TestError.test)
        } else {
            return stubbedExecuteResult
        }
    }
    
    func add(with dto: NoteDTO, character: CharacterDTO) -> Single<NoteDTO> {
        isCalled = true
        lastNoteDTO = dto
        lastCharacterDTO = character
        
        if isFailed {
            return .error(TestError.test)
        } else {
            return stubbedAddResult
        }
    }
    
    func fetchAllNotes() -> Single<[NoteDTO]> {
        isCalled = true
        
        if isFailed {
            return .error(TestError.test)
        } else {
            return stubbedExecuteResult
        }
    }
}
