//
//  CharacterRepositoryImpl.swift
//  BioLog
//
//  Created by 이현욱 on 3/11/25.
//

import Foundation

import RxSwift
import RxCocoa

final class CharacterRepositoryImpl: CharacterRepository {
    
    private let storage: StorageAble
    
    init(storage: StorageAble) {
        self.storage = storage
    }
    
    func create(book: BookDTO, character: CharacterDTO) -> Observable<CharacterDTO> {
        storage.create(character)
            .flatMap { character -> Observable<CharacterDTO> in
                // 책과의 관계 설정
                character.book = book.originalObject!
                
                // 저장
                do {
                    try self.storage.save()
                } catch {
                    return Observable.error(error)
                }
                
                return Observable.just(character.toDTO()) // 저장된 캐릭터 반환
            }
    }
    
    func fetch(by id: String) -> Single<[CharacterDTO]> {
        let predicate = NSPredicate(format: "book.isbn = %@", id)
        
        return storage.fetch(BookCharacter.self, predicate: predicate, sortDescriptors: nil)
            .map { characters in
                characters.map { $0.toDTO() }
            }
            .asSingle()
    }
    
    func updateCharacter(with dto: CharacterDTO) -> Completable {
        let predicate = NSPredicate(format: "uuid = %@", dto.uuid)
        
        return storage.fetch(BookCharacter.self, predicate: predicate, sortDescriptors: nil)
            .compactMap { $0.first }
            .flatMap { character -> Completable in
                character.name = dto.name
                character.sex = dto.sex
                character.age = dto.age
                character.labor = dto.labor
                character.note = NSSet(array: dto.notes.compactMap { $0.originalObject })
                do {
                    try self.storage.save()
                }
                
                return self.storage.update(character)
            }.asCompletable()
    }
    
    func fetchAllCharacter() -> Single<[CharacterDTO]> {
        return storage.fetch(BookCharacter.self, predicate: nil, sortDescriptors: nil)
            .map { $0.map { $0.toDTO() } }
            .asSingle()
    }
    
    private func fetchBook(id: String) -> Observable<Book> {
        let predicate = NSPredicate(format: "isbn = %@", id)
        
        return storage.fetch(Book.self, predicate: predicate, sortDescriptors: nil)
            .compactMap { books -> Book? in
                guard let book = books.first else {
                    return .none
                }
                
                return book
            }
    }
}
