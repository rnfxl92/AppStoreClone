//
//  Session.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import Foundation

final class Session {
    static let shared = Session(userDefaults: UserDefaults.standard)
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    private let recentKeywordsKey: String = "RECENT_KEYWORDS"
    
    func getUserDefaults() -> UserDefaults {
        return userDefaults
    }
    
    func getRecentSearchKeywords() -> [KeywordModel]? {
        if let data = getUserDefaults().value(forKey: recentKeywordsKey) as? Data {
            return try? PropertyListDecoder().decode([KeywordModel].self, from: data)
        }
        return nil
    }
    
    func setRecentSearchKeywords(_ keywords: [KeywordModel]) {
        getUserDefaults().set(try? PropertyListEncoder().encode(keywords), forKey: recentKeywordsKey)
    }
    
}
