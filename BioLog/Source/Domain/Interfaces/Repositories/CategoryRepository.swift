//
//  CategoryRepository.swift
//  BioLog
//
//  Created by 이현욱 on 4/15/25.
//

import Foundation
import CoreData

import RxSwift
import RxCocoa

protocol CategoryRepository {
    func create(with category: CategoryDTO, book: BookDTO) -> Single<CategoryDTO>
//    func delete(character: CharacterDTO) -> Single<CharacterDTO>
//    func fetch(by id: String) -> Single<[CategoryDTO]>
//    func updateCategory(with dto: CategoryDTO) -> Completable
    func getAllCategories() -> Single<[CategoryDTO]>
}
