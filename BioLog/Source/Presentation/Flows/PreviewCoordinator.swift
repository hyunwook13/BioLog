//
//  PreviewCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 4/14/25.
//

import UIKit

final class PreviewCoordinator: Coordinator {

    weak var parentCoordinator: Coordinator?
    
    var nav: UINavigationController
    var childCoordinators = [Coordinator]()
    private let container: PreviewDIContainer
    
    init(nav: UINavigationController, container: PreviewDIContainer) {
        self.container = container
        self.nav = nav
    }
    
    func start() {
        let vc = container.makePreviewViewController()
        vc.hidesBottomBarWhenPushed = true
        nav.pushViewController(vc, animated: true)
    }
}
