//
//  MockCategoryRepositoryImpl.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/17/25.
//

import Foundation

import RxSwift
import RxCocoa

@testable import BioLog

final class MockCategoryRepositoryImpl: CategoryRepository {
    
    var isCalled = false
    var stubbedCategories: Single<BioLog.CategoryDTO> = .just(.empty)
    var stubbedAllCategories: Single<[BioLog.CategoryDTO]> = .just([])
    
    func create(with category: BioLog.CategoryDTO, book: BioLog.BookDTO) -> RxSwift.Single<BioLog.CategoryDTO> {
        isCalled = true
        return stubbedCategories
    }
    
    func getAllCategories() -> RxSwift.Single<[BioLog.CategoryDTO]> {
        isCalled = true
        return stubbedAllCategories
    }
}
