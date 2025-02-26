//
//  Coordinator.swift
//  HaloGlow
//
//  Created by 이현욱 on 1/21/25.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    func start()
}

extension Coordinator {
    func removeChild(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
            }
        }
    }
}
