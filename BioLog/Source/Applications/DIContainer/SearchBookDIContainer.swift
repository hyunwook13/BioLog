//
//  SearchBookDIContainer.swift
//  BioLog
//
//  Created by 이현욱 on 2/27/25.
//

import UIKit

final class SearchBookDIContainer {
    
    private let usecase: BookUseCaseAble
    
    init(bookUseCase: BookUseCaseAble) {
        self.usecase = bookUseCase
    }
    
    func makeSearchBookViewController(_ actions: SearchBookAction) -> SearchBookViewController {
        let vm = makeSearchBookViewModel(actions)
        return SearchBookViewController(vm: vm)
    }
    
    func makeSearchBookViewModel(_ actions: SearchBookAction) -> SearchBookViewModel {
        return SearchBookViewModel(usecase: usecase, action: actions)
    }
    
    func makeSearchBookCoordinator(nav: UINavigationController) -> SearchBookCoordinator {
        return SearchBookCoordinator(nav: nav, container: self)
    }
}
