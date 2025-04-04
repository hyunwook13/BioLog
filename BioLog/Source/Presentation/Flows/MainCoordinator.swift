//
//  MainCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit

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
            addHandler: presentSearchBookVC,
            selectedReadingBookHandler: pushWithReadingBook,
            selectedNewBookHandler: pushWithNewBook,
            chartHandler: chart
        )
        let vc = container.makeMainViewController(actions)
        nav.setViewControllers([vc], animated: false)
    }
    
    private func presentSearchBookVC() {
        let searchBookDIContainer = container.makeSearchBookDIContainer()
        let childCoor = searchBookDIContainer.makeSearchBookCoordinator(nav: nav)
        
        self.childCoordinators.append(childCoor)
        childCoor.parentCoordinator = self
        childCoor.start()
    }
    
    private func pushWithReadingBook(_ book: CompleteBook) {
        let bookInfoDIContainer = container.makeBookInfoDIContainer(book: book)
        let childCoor = bookInfoDIContainer.makeBookInfoCoordinator(nav: nav)
        
        self.childCoordinators.append(childCoor)
        childCoor.parentCoordinator = self
        childCoor.start()
    }
    
    private func pushWithNewBook(_ book: CompleteBook) {
        let bookInfoDIContainer = container.makePreviewDIContainer(book: book)
        let childCoor = bookInfoDIContainer.makePreviewCoordinator(nav: nav)
        
        self.childCoordinators.append(childCoor)
        childCoor.parentCoordinator = self
        childCoor.start()
    }
    
    
    private func chart() {
        if #available(iOS 16.0, *) {
            let bookInfoDIContainer = container.makeChartDIContainer()
            let childCoor = bookInfoDIContainer.makeChartCoordinator(nav: nav)
            
            self.childCoordinators.append(childCoor)
            childCoor.parentCoordinator = self
            childCoor.start()
        } else {
            // 이전 버전에서는 지원하지 않는 기능
        }
    }
}
