//
//  BookInfoCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 3/7/25.
//

import UIKit

protocol BookInfoAction {
    func pop()
    func pushCharacter(_ character: CharacterDTO)
}

struct BookInfoActionAble: BookInfoAction {
    
    let popHandler: () -> Void
    let pushWithCharacter: (CharacterDTO) -> Void
    
    func pop() {
        popHandler()
    }
    
    func pushCharacter(_ character: CharacterDTO) {
        pushWithCharacter(character)
    }
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
    
    deinit {
        print("BookInfoCoordinator deinit")
    }
    
    func start() {
        let actions = BookInfoActionAble(
            popHandler: pop,
            pushWithCharacter: pushCharacter(_:)
        )
        
        let vc = container.makeBookInfoViewController(actions)
        vc.hidesBottomBarWhenPushed = true
        nav.navigationBar.tintColor = .label
        nav.pushViewController(vc, animated: true)
        
        // 시스템 back 버튼의 동작 커스텀
        nav.interactivePopGestureRecognizer?.delegate = nil
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "뒤로",
            style: .plain,
            target: self,
            action: #selector(customDismiss)
        )
    }
    
    @objc private func customDismiss() {
        parentCoordinator?.removeChild(self)
        pop()
    }
    
    private func pushCharacter(_ character: CharacterDTO) {
        let container = container.makeEditCharcterDIContainer(character: character)
        let childCoor = container.makeEditCharacterCoordinator(nav: nav)
        
        self.childCoordinators.append(childCoor)
        childCoor.parentCoordinator = self
        childCoor.start()
    }
    
    private func pop() {
        nav.popViewController(animated: true)
    }
}
