//
//  NoteUseCase.swift
//  BioLog
//
//  Created by 이현욱 on 3/11/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol NoteUseCase {
    func execute(isbn: String) -> Single<[NoteDTO]>
    func add(with: NoteDTO, character: CharacterDTO) -> Single<NoteDTO>
    func updateNote(with dto: NoteDTO) -> Completable
    func fetchAllNotes() -> Single<[NoteDTO]>
}

class NoteUseCaseImpl: NoteUseCase {

    private let repository: NoteRepository
    
    init(repository: NoteRepository) {
        self.repository = repository
    }
    
    func add(with: NoteDTO, character: CharacterDTO) -> Single<NoteDTO> {
        return repository.add(with: with, book: character)
    }
    
    func execute(isbn: String) -> Single<[NoteDTO]> {
        return repository.fetchNotes(isbn: isbn)
    }
    
    func updateNote(with dto: NoteDTO) -> RxSwift.Completable {
        return repository.updateNote(with: dto)
    }
    
    func fetchAllNotes() -> Single<[NoteDTO]> {
        return repository.fetchAllNotes()
    }
}
