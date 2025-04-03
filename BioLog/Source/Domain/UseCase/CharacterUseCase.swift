//
//  CharacterUsecase.swift
//  BioLog
//
//  Created by 이현욱 on 3/11/25.
//

import Foundation

import RxSwift
import RxCocoa

// Define use case protocol for fetching book characters
protocol CharactersUseCase {
    func execute(isbn: String) -> Single<[CharacterDTO]>
    func add(with dto: CharacterDTO, book: BookDTO) -> Single<CharacterDTO>
    func updateCharacter(with dto: CharacterDTO) -> Completable
    func fetchAllCharacter() -> Single<[CharacterDTO]>
}

// Default implementation of the use case
class CharactersUseCaseImpl: CharactersUseCase {

    private let repo: CharacterRepository
    
    init(repo: CharacterRepository) {
        self.repo = repo
    }
    
    func execute(isbn: String) -> Single<[CharacterDTO]> {
        return repo.fetch(by: isbn)
    }
    
    func add(with dto: CharacterDTO, book: BookDTO) -> Single<CharacterDTO> {
        return repo.create(book: book, character: dto).asSingle()
    }
    
    func updateCharacter(with dto: CharacterDTO) -> RxSwift.Completable {
        return repo.updateCharacter(with: dto)
    }
    
    func fetchAllCharacter() -> Single<[CharacterDTO]> {
        return repo.fetchAllCharacter()
    }
}
