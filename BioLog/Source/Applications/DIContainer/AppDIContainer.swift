//
//  AppDIContainer.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import Foundation

final class AppDIContainer {
    
    let bookUseCase: BookUseCaseImpl
    let categoryUseCase: CategoryUseCase
    let storage: StorageAble
    
    init() {
        let stack = BioLogCoreDataStack.shared
        
        let storage = CoreData(
            mainContext: stack.mainContext,
            container: stack.persistentContainer
        )
        
        let bookRepo = BookRepositoryImpl(
            client: ClientImpl(),
            storage: storage
        )
        
        let categoryRepo = CategoryRepositoryImpl(storage)
        
        self.storage = storage
        self.bookUseCase = BookUseCaseImpl(repo: bookRepo)
        self.categoryUseCase = CategoryUseCaseImpl(categoryRepo)
    }
    
    func makeMainDiContainer() -> MainDiContainer {
        return MainDiContainer(bookUseCase: bookUseCase, categoryUseCase: categoryUseCase, storage: storage)
    }
    
    func makeBookshelfDIContainer() -> BookshelfDIContainer {
        return BookshelfDIContainer(bookUseCase)
    }
}
