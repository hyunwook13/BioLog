//
//  BookshelfDIContainer.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit

final class BookshelfDIContainer {
    func makeBookshelfViewController() -> BookShelfViewController {
        return BookShelfViewController()
    }
    
    func makeBookShelfCoordinator(nav: UINavigationController) -> BookShelfCoordinator {
        return BookShelfCoordinator(nav: nav, container: self)
    }
}
