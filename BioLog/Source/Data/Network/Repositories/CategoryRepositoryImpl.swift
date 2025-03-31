//
//  CategoryRepositoryImpl.swift
//  BioLog
//
//  Created by 이현욱 on 4/15/25.
//

import Foundation
import CoreData

import RxSwift
import RxCocoa

final class CategoryRepositoryImpl: CategoryRepository {
    private let storage: StorageAble
    
    init(_ storage: StorageAble) {
        self.storage = storage
    }
    
    func create(with category: CategoryDTO, book: BookDTO) -> Single<CategoryDTO> {
        return self.storage.fetch(Category.self, predicate: nil, sortDescriptors: nil)
            .map { $0.map { $0.toDTO() } }
            .flatMap { dtos in
                if dtos.contains(where: { $0.name == category.name }) {
                    return Observable.of(category)
                } else {
                    return self.storage.create(category)
                        .map { $0.toDTO() }
                        .asObservable()
                }
            }.map { dto in
                dto.original?.books?.adding(book.originalObject!)
                
                do {
                    try self.storage.save()
                } catch {
                    
                }
                
                return dto
            }.asSingle()
    }
    
    func getAllCategories() -> RxSwift.Single<[CategoryDTO]> {
        storage.fetch(Category.self, predicate: nil, sortDescriptors: nil)
            .map { $0.map { $0.toDTO() } }
            .asSingle()
    }
}
