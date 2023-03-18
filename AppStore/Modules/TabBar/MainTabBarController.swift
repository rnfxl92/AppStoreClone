//
//  MainTabBarController.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private let today = TodayViewController.initFromNib() ?? TodayViewController()
    private let game = GameViewController.initFromNib() ?? GameViewController()
    private let app = AppViewController.initFromNib() ?? AppViewController()
    private let arcade = ArcadeViewController.initFromNib() ?? ArcadeViewController()
    private let search = SearchViewController.initFromNib() ?? SearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setupViewControllers()
        setupTabBar()
        addTabButtons()
    }
    
    private func setupViewControllers() {
        viewControllers = [
            UINavigationController(rootViewController: today),
            UINavigationController(rootViewController: game),
            UINavigationController(rootViewController: app),
            UINavigationController(rootViewController: arcade),
            UINavigationController(rootViewController: search)
        ]
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = .systemBackground
        tabBar.tintColor = .link
    }
    
    private func addTabButtons() {
        for (index, tab) in TabBarItem.allCases.enumerated() {
            let tabBarItem = tabBar.items?[safe: index]
            
            tabBarItem?.tag = tab.rawValue
            tabBarItem?.image = tab.image
            tabBarItem?.selectedImage = tab.image
                

            if #available(iOS 15.0, *) {
                tabBarItem?.title = tab.title
            } else {
                // 앞뒤 ' '(공백)의 이유 : iOS 13이상 15미만에서 UITabBarItem title을 bold로 적용 할 시, title에 영문자가 포함되어있을 경우 '...'처리가 됩니다.
                tabBarItem?.title = " " + tab.title + " "
            }
           
        }
    }
    
}

extension MainTabBarController: UITabBarControllerDelegate {
    
}
