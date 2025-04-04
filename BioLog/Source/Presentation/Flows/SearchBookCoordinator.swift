//
//  SearchBookCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit

protocol SearchBookActionAble {
    func cancel()
    func selected(_ book: CompleteBook)
}

struct SearchBookAction: SearchBookActionAble {
    let cancelHandler: () -> Void
    let selectedHandler: (CompleteBook) -> Void
    
    func cancel() {
        cancelHandler()
    }
    
    func selected(_ book: CompleteBook) {
        selectedHandler(book)
    }
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
    
    deinit {
        print("SearchBookCoordinator deinit")
    }
    
    func start() {
        let actions = SearchBookAction(
            cancelHandler: { [weak self] in
                self?.dismiss()
            },
            selectedHandler: { [weak self] book in
                self?.dismissWithBook(book)
            }
        )
        
        let vc = container.makeSearchBookViewController(actions)
        let navedVC = UINavigationController(rootViewController: vc)
        navedVC.navigationBar.tintColor = .label
        nav.present(navedVC, animated: true)
    }
    
    private func dismiss() {
        parentCoordinator?.removeChild(self)
        nav.dismiss(animated: true)
    }
    
    private func dismissWithBook(_ book: CompleteBook) {
//        didSelectData?(book)
        
        dismiss()
    }
}
