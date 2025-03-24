//
//  MockCategoryUseCaseImpl.swift
//  BioLogTests
//
//  Created by 이현욱 on 4/17/25.
//

import Foundation
import RxSwift
import RxCocoa

@testable import BioLog

final class MockCategoryUseCaseImpl: CategoryUseCase {
    
    var isCalled = false
    var lastCalledName: String!
    var stubbedCategories: Single<BioLog.CategoryDTO> = .just(.empty)
    var stubbedAllCategories: Single<[BioLog.CategoryDTO]> = .just([])
    
    func saveCategory(_ name: String, _ relation: BioLog.BookDTO) -> RxSwift.Single<BioLog.CategoryDTO> {
        isCalled = true
        lastCalledName = name
        return stubbedCategories
    }
    
    func getAllCategory() -> RxSwift.Single<[BioLog.CategoryDTO]> {
        isCalled = true
        return stubbedAllCategories
    }
}
