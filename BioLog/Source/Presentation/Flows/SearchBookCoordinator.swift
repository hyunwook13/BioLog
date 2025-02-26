//
//  SearchBookCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit

struct SearchBookAction {
    let cancel: () -> Void
}

final class SearchBookCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    private let container: SearchBookDIContainer
    let nav: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(nav: UINavigationController, container: SearchBookDIContainer) {
        self.container = container
        self.nav = nav
    }
    
    func start() {
        let actions = SearchBookAction(cancel: dismiss)
        
        let vc = container.makeSearchBookViewController(actions)
        nav.present(vc, animated: true)
    }
    
    private func dismiss() {
        nav.dismiss(animated: true)
    }
}
