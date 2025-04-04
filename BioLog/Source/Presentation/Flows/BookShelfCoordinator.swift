//
//  BookShelfCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit

final class BookShelfCoordinator: Coordinator {
    private let nav: UINavigationController
    private let container: BookshelfDIContainer
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators = [Coordinator]()
    
    init(nav: UINavigationController, container: BookshelfDIContainer) {
        self.nav = nav
        self.container = container
    }
    
    func start() {
        let actions = BookShelfAction(
            popHandler: pop,
            pushWithBookHandler: pushWithBook
        )
        
        let vc = container.makeBookshelfViewController(actions: actions)
        
        nav.setViewControllers([vc], animated: false)
    }
    
    private func pop() {
        parentCoordinator?.removeChild(self)
        nav.popViewController(animated: true)
    }
    
    private func pushWithBook(book: BookDTO) {
        let completeBook = CompleteBook(detail: book, category: book.category, characters: [])
        let bookInfoDIContainer = container.makePreviewDIContainer(book: completeBook)
        let childCoor = bookInfoDIContainer.makePreviewCoordinator(nav: nav)
        
        self.childCoordinators.append(childCoor)
        childCoor.parentCoordinator = self
        childCoor.start()
    }
    
}
