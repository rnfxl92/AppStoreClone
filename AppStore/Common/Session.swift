//
//  Session.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import Foundation

final class Session {
    static let shared = Session()
    
    private init() {}
    
    private let recentKeywordsKey: String = "RECENT_KEYWORDS"
    
    func getUserDefaults() -> UserDefaults {
        let userDefaults: UserDefaults = UserDefaults.standard
        return userDefaults
    }
    
    func getRecentSearchKeywords() -> [KeywordModel]? {
        if let data = UserDefaults.standard.value(forKey: recentKeywordsKey) as? Data {
            return try? PropertyListDecoder().decode([KeywordModel].self, from: data)
        }
        return nil
    }
    
    func setRecentSearchKeywords(_ keywords: [KeywordModel]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(keywords), forKey: recentKeywordsKey)
    }
    
}
