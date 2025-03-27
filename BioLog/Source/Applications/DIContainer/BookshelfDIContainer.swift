//
//  BookshelfDIContainer.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit

final class BookshelfDIContainer {
    
    private let usecase: BookUseCaseImpl
    
    init(_ usecase: BookUseCaseImpl) {
        self.usecase = usecase
    }
     
    func makeBookshelfViewController(actions: BookShelfActionAble) -> BookShelfViewController {
        let vm = makeBookShelfViewModel(actions: actions)
        return BookShelfViewController(vm)
    }
    
    func makeBookShelfCoordinator(nav: UINavigationController) -> BookShelfCoordinator {
        return BookShelfCoordinator(nav: nav, container: self)
    }
    
    func makeBookShelfViewModel(actions: BookShelfActionAble) -> BookShelfViewModel {
        return BookShelfViewModel(usecase: usecase, action: actions)
    }
    
    func makePreviewDIContainer(book: CompleteBook) -> PreviewDIContainer{
        return PreviewDIContainer(book: book, bookUseCase: usecase)
    }
}
