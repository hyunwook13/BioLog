//
//  MainCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit


struct MainAction {
    let add: () -> Void
    let selectedBook: (BookDTO) -> Void
}

final class MainCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var nav: UINavigationController
    var childCoordinators = [Coordinator]()
    private let container: MainDiContainer
    
    init(nav: UINavigationController, container: MainDiContainer) {
        self.container = container
        self.nav = nav
    }
    
    func start() {
        let actions = MainAction(
            add: presentSearchBookVC,
            selectedBook: dismissWithBook
        )
        let vc = container.makeMainViewController(actions)
        nav.setViewControllers([vc], animated: false)
    }
    
    private func presentSearchBookVC() {
        let searchBookDIContainer = container.makeSearchBookDIContainer()
        let childCoor = searchBookDIContainer.makeSearchBookCoordinator(nav: nav)
        
//        childCoor.didSelectData = {
//            nav.topViewController
//        }
        
        self.childCoordinators.append(childCoor)
        childCoor.start()
    }
    
    private func dismissWithBook(_ book: BookDTO) {
        
    }
}
