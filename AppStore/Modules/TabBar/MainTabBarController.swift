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
        selectedIndex = TabBarItem.search.rawValue
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
            tabBarItem?.title = tab.title
        }
    }
    
}

extension MainTabBarController: UITabBarControllerDelegate {
    
}
