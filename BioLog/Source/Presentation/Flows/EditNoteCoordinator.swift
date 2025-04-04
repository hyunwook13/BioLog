//
//  EditNoteCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 4/15/25.
//

import UIKit

final class EditNoteCoordinator: Coordinator {
    private let nav: UINavigationController
    private let container: EditNoteDIContainer
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators = [Coordinator]()
    
    init(nav: UINavigationController, container: EditNoteDIContainer) {
        self.nav = nav
        self.container = container
    }
    
    func start() {
        let action = EditNoteActionAble(
            popHandler: pop
            )
        let vc = container.makeEditNoteViewController(action: action)
        nav.pushViewController(vc, animated: true)
    }
    
    private func pop() {
        nav.popViewController(animated: true)
    }
}
    
