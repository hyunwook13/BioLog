//
//  NoteRepositoryImpl.swift
//  BioLog
//
//  Created by 이현욱 on 3/14/25.
//

import Foundation

import RxSwift
import RxCocoa

final class NoteRepositoryImpl: NoteRepository {
    
    private let storage: StorageAble
    
    init(storage: StorageAble) {
        self.storage = storage
    }
    
    func fetchAllNotes() -> Single<[NoteDTO]> {
        return storage.fetch(Note.self, predicate: nil, sortDescriptors: nil)
            .map { $0.map { $0.toDTO() } }
            .asSingle()
    }
    
    func add(with note: NoteDTO, book: CharacterDTO) -> Single<NoteDTO> {
        return storage.create(note)
            .flatMap { note -> Observable<NoteDTO> in
                // 책과의 관계 설정
                note.character = book.original!
                
                // 저장
                do {
                    try self.storage.save()
                } catch {
                    return Observable.error(error)
                }
                
                return Observable.just(note.toDTO()) // 저장된 캐릭터 반환
            }
            .asSingle()
    }
    
    func fetchNotes(isbn: String) -> Single<[NoteDTO]> {
        let predicate = NSPredicate(format: "book.isbn = %@", isbn)
        
        return storage.fetch(Note.self, predicate: predicate, sortDescriptors: nil)
            .map { characters in
                characters.map { $0.toDTO() }
            }
            .asSingle()
    }
    
    func updateNote(with dto: NoteDTO) -> RxSwift.Completable {
        let predicate = NSPredicate(format: "uuid = %@", dto.uuid)
        
        return storage.fetch(Note.self, predicate: predicate, sortDescriptors: nil)
            .compactMap { $0.first }
            .flatMap { note -> Completable in
                note.page = dto.page
                note.context = dto.context
                do {
                    try self.storage.save()
                }
                
                return self.storage.update(note)
                
            }.asCompletable()
    }
    
    private func fetchBook(id: String) -> Observable<Book> {
        let predicate = NSPredicate(format: "isbn = %@", id)
        
        return storage.fetch(Book.self, predicate: predicate, sortDescriptors: nil)
            .compactMap { $0.first }
    }
    
    //    func update(with note: NoteDTO) -> Single<NoteDTO> {
    //        return storage.update(collection: .notes, id: note.id, data: note)
    //    }
    //
    //    func delete(id: String) -> Single<Void> {
    //        return storage.delete(collection: .notes, id: id)
    //    }
}
