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
        let vc = container.makeBookshelfViewController()
        
        nav.setViewControllers([vc], animated: false)
    }
    
    
}
