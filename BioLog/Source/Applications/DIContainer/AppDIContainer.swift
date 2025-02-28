//
//  AppDIContainer.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import Foundation

final class AppDIContainer {
    
    let bookUseCase: BookUseCaseAble
    
    init() {
        self.bookUseCase = BookUseCase(repo: BookRepositoryImpl(client: ClientImpl()))
    }
    
    func makeMainDiContainer() -> MainDiContainer {
        return MainDiContainer(bookUseCase: bookUseCase)
    }
    
    func makeBookshelfDIContainer() -> BookshelfDIContainer {
        return BookshelfDIContainer()
    }
}
