//
//  CategoryUseCase.swift
//  BioLog
//
//  Created by 이현욱 on 4/15/25.
//

import Foundation
import CoreData

import RxSwift
import RxCocoa

protocol CategoryUseCase {
    func saveCategory(_ name: String, _ relation: BookDTO) -> Single<CategoryDTO>
    func getAllCategory() -> Single<[CategoryDTO]>
}

final class CategoryUseCaseImpl: CategoryUseCase {
    private let repo: CategoryRepository
    
    init(_ repo: CategoryRepository) {
        self.repo = repo
    }
    
    func saveCategory(_ name: String, _ relation: BookDTO) -> RxSwift.Single<CategoryDTO> {
        let category = makeCategory(with: name)
        
        return repo.create(with: category, book: relation)
    }
    
    func getAllCategory() -> Single<[CategoryDTO]> {
        return repo.getAllCategories()
    }
    
    private func makeCategory(with data: String) -> CategoryDTO {
        let name = data.split(separator: ">").last.map { String($0) } ?? ""
        return CategoryDTO(name: name)
    }
}
