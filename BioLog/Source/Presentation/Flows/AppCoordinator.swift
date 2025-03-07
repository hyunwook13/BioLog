//
//  AppCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit

import SnapKit

final class AppCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    private let container: AppDIContainer
    var childCoordinators = [Coordinator]()
    var nav: UINavigationController
    private let tabbar = CustomTabBarController()
    
    init(nav: UINavigationController, _ appDICotainer: AppDIContainer) {
        self.container = appDICotainer
        self.nav = nav
    }
    
    func start() {
        let tabs = makeTabs()
        
        // 탭바에 ViewController 설정
        nav.setViewControllers([tabbar], animated: false)
        tabbar.viewControllers = tabs.viewControllers
        
        // Coordinator 초기화 및 시작
        tabs.coordinators.forEach { coordinator in
            childCoordinators.append(coordinator)
            coordinator.parentCoordinator = self
            coordinator.start()
        }
        
        settingTabs()
    }
    
    // 탭을 생성하는 메서드로 관심사 분리
    private func makeTabs() -> (viewControllers: [UIViewController], coordinators: [Coordinator]) {
        // 각 DIContainer 초기화
        let mainDIContainer = container.makeMainDiContainer()
        let bookShelfDIContainer = container.makeBookshelfDIContainer()
        
        // Daily 탭
        let mainNav = UINavigationController()
        let mainCoordinator = mainDIContainer.makeMainCoordinator(nav: mainNav)
        
        // Chart 탭
        let bookShelfNav = UINavigationController()
        bookShelfNav.setNavigationBarHidden(true, animated: false)
        let bookShelfCoordinator = bookShelfDIContainer.makeBookShelfCoordinator(nav: bookShelfNav)
        
        return (
            viewControllers: [mainNav, bookShelfNav],
            coordinators: [mainCoordinator, bookShelfCoordinator]
        )
    }
    
    private func settingTabs() {
        tabbar.viewControllers?[0].tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 0)
        tabbar.viewControllers?[1].tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "book.closed"), tag: 1)
    }
}
