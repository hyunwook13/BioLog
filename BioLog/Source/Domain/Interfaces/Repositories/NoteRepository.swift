//
//  NoteRepository.swift
//  BioLog
//
//  Created by 이현욱 on 3/14/25.
//

import Foundation

import RxCocoa
import RxSwift

protocol NoteRepository {
    func add(with: NoteDTO, book: CharacterDTO) -> Single<NoteDTO>
    func fetchNotes(isbn: String) -> Single<[NoteDTO]>
    func updateNote(with: NoteDTO) -> Completable
    func fetchAllNotes() -> Single<[NoteDTO]>
}
