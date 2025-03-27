//
//  SearchBookDIContainer.swift
//  BioLog
//
//  Created by 이현욱 on 2/27/25.
//

import UIKit

final class SearchBookDIContainer {
    
    private let bookUseCase: BookUseCase
    private let categoryUseCase: CategoryUseCase
    
    init(bookUseCase: BookUseCase, categoryUseCase: CategoryUseCase) {
        self.bookUseCase = bookUseCase
        self.categoryUseCase = categoryUseCase
    }
    
    func makeSearchBookViewController(_ actions: SearchBookActionAble) -> SearchBookViewController {
        let vm = makeSearchBookViewModel(actions)
        return SearchBookViewController(vm: vm)
    }
    
    func makeSearchBookViewModel(_ actions: SearchBookActionAble) -> SearchBookViewModel {
        return SearchBookViewModel(
            categoryUseCase: categoryUseCase,
            bookUseCase: bookUseCase,
            action: actions
        )
    }
    
    func makeSearchBookCoordinator(nav: UINavigationController) -> SearchBookCoordinator {
        return SearchBookCoordinator(nav: nav, container: self)
    }
}
