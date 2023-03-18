//
//  TabBarItem.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import UIKit

enum TabBarItem: Int, CaseIterable {
    case today
    case game
    case app
    case arcade
    case search
    
    var image: UIImage? {
        switch self {
        case .today:
            return UIImage(systemName: "doc.text.image")
        case .game:
            return UIImage(systemName: "gamecontroller")
        case .app:
            return UIImage(systemName: "square.stack.3d.up.fill")
        case .arcade:
            return UIImage(systemName: "playstation.logo")
        case .search:
            return UIImage(systemName: "magnifyingglass")
        }
    }

    var title: String {
        switch self {
        case .today:
            return "today.title".localized()
        case .game:
            return "game.title".localized()
        case .app:
            return "app.title".localized()
        case .arcade:
            return "arcade.title".localized()
        case .search:
            return "search.title".localized()
        }
    }

}
