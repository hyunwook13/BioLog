//
//  ChartCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 4/17/25.
//

import UIKit


struct ChartActionAble {
    let popHandler: () -> Void
}

@available(iOS 16.0, *)
final class ChartCoordinator: Coordinator {
    private let nav: UINavigationController
    private let container: ChartDIContainer
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators = [Coordinator]()
    
    init(nav: UINavigationController, container: ChartDIContainer) {
        self.nav = nav
        self.container = container
    }
    
    func start() {
        let actions = ChartActionAble(
            popHandler: pop
        )
        let vc = container.makeChartViewController(action: actions)
        vc.modalPresentationStyle = .fullScreen
        nav.present(vc, animated: true)
    }
    
    private func pop() {
        nav.dismiss(animated: true)
        parentCoordinator?.removeChild(self)
    }
}
