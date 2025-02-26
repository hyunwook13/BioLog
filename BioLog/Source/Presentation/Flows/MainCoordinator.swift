//
//  MainCoordinator.swift
//  HaloGlow
//
//  Created by 이현욱 on 1/21/25.
//

import UIKit

struct MissionsViewModelActions {
//    let showMovieDetails: (MissionImpl) -> Void
}

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
//        let actions = MissionsViewModelActions(showMovieDetails: presentToDaliyVC)
        let vc = container.makeMainViewController()
        nav.setViewControllers([vc], animated: false)
    }
    
//    private func presentToDaliyVC(_ selectedData: MissionImpl) {
////        let dailyTaskDIContainer = container.makeDailyTaskDiContainer(mission: selectedData)
////        let vc = dailyTaskDIContainer.makeDailyTasksViewController(mission: selectedData)
////        let childCoor = dailyTaskDIContainer.makeDailyTasksCoordinator(nav: nav)
////        
////        self.childCoordinators.append(childCoor)
////        childCoor.start()
////        vc.modalPresentationStyle = .fullScreen
////        nav.present(vc, animated: true)
//    }
}
