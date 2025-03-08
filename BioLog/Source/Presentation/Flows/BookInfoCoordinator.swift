//
//  BookInfoCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 3/7/25.
//

import UIKit

struct BookInfoAction {
    let dismiss: () -> Void
}

final class BookInfoCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    private let container: BookInfoDIContainer
    let nav: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(nav: UINavigationController, container: BookInfoDIContainer) {
        self.container = container
        self.nav = nav
    }
    
    func start() {
        let actions = BookInfoAction(
            dismiss: dismiss
        )
        
        let vc = container.makeBookInfoViewController(actions)
        nav.pushViewController(vc, animated: true)
    }
    
    private func dismiss() {
        nav.popViewController(animated: true)
    }
}
