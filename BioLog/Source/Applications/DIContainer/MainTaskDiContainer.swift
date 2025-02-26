//
//  MainTaskDiContainer.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit

final class MainDiContainer {
    
    private let usecase: BookUseCaseAble
    
    init(bookUseCase: BookUseCaseAble) {
        self.usecase = bookUseCase
    }
    
    func makeMainViewController(_ actions: MainAction) -> MainViewController {
        let vm = makeMainViewModel(actions)
        return MainViewController(vm: vm)
    }
    
    func makeMainViewModel(_ actions: MainAction) -> MainViewModel {
        return MainViewModel(usecase: usecase, actions: actions)
    }
    
    func makeMainCoordinator(nav: UINavigationController) -> MainCoordinator {
        return MainCoordinator(nav: nav, container: self)
    }
    
    func makeSearchBookDIContainer() -> SearchBookDIContainer {
        return SearchBookDIContainer(bookUseCase: usecase)
    }
}
