//
//  MockNoteRepositoryImpl.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/17/25.
//

import Foundation

import RxSwift
import RxCocoa

@testable import BioLog

final class MockNoteRepositoryImpl: NoteRepository {
    
    var isCalled = false
    var lastCalledNote: NoteDTO?
    var lastCalledBook: CharacterDTO?
    var lastCalledIsbn: String?
    
    var stubbedSavedResult: Single<[NoteDTO]> = .just([]) // 기본값
    var stubbedAddResult: Single<NoteDTO> = .just(.empty) // 기본값
    
    func add(with: NoteDTO, book: CharacterDTO) -> Single<NoteDTO> {
        isCalled = true
        lastCalledBook = book
        lastCalledNote = with
        stubbedAddResult = .just(with)
        return stubbedAddResult
    }
    
    func fetchNotes(isbn: String) -> RxSwift.Single<[BioLog.NoteDTO]> {
        isCalled = true
        lastCalledIsbn = isbn
        return stubbedSavedResult
    }
    
    func updateNote(with: BioLog.NoteDTO) -> RxSwift.Completable {
        isCalled = true
        lastCalledNote = with
        return Completable.empty()
    }
    
    func fetchAllNotes() -> RxSwift.Single<[BioLog.NoteDTO]> {
        isCalled = true
        return stubbedSavedResult
    }
}
