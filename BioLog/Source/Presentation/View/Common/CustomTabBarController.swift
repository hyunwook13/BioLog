//
//  CustomTabBarController.swift
//  BioLog
//
//  Created by 이현욱 on 2/25/25.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupCustomViewOnTabBar()
    }

    private func setupCustomViewOnTabBar() {
        let seperateView = UIView()
        seperateView.backgroundColor = .gray
        
        self.view.addSubview(seperateView)
        
        seperateView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(self.tabBar.snp.top)
        }
    }
}
