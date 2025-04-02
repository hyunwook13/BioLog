//
//  CharacterRepository.swift
//  BioLog
//
//  Created by 이현욱 on 3/11/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol CharacterRepository {
    func create(book: BookDTO, character: CharacterDTO) -> Observable<CharacterDTO>
//    func delete(character: CharacterDTO) -> Single<CharacterDTO>
    func fetch(by id: String) -> Single<[CharacterDTO]>
    func updateCharacter(with dto: CharacterDTO) -> Completable
    func fetchAllCharacter() -> Single<[CharacterDTO]>
}
