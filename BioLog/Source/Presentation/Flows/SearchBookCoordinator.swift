//
//  SearchBookCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit

struct SearchBookAction {
    let cancel: () -> Void
    let selected: (BookDTO) -> Void
}

final class SearchBookCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    private let container: SearchBookDIContainer
    let nav: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    var didSelectData: ((BookDTO) -> Void)?
    
    init(nav: UINavigationController, container: SearchBookDIContainer) {
        self.container = container
        self.nav = nav
    }
    
    func start() {
        let actions = SearchBookAction(
            cancel: dismiss,
            selected: dismissWithBook
        )
        
        let vc = container.makeSearchBookViewController(actions)
        let navedVC = UINavigationController(rootViewController: vc)

        nav.present(navedVC, animated: true)
    }
    
    private func dismiss() {
        nav.dismiss(animated: true)
    }
    
    private func dismissWithBook(_ book: BookDTO) {
        didSelectData?(book)
        nav.dismiss(animated: true)
    }
}
