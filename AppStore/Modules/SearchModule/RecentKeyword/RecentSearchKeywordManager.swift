//
//  RecentKeywordManager.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import Foundation

final class RecentSearchKeywordManager {
    
    static let shared: RecentSearchKeywordManager = RecentSearchKeywordManager()
    private let maxKeywordLimit: Int = 100 // 임의로 최대값 100개 제한
    
    private init() {}
    
    func getKeywords() -> [KeywordModel] {
        if var array = Session.shared.getRecentSearchKeywords() {
            array.sort {
                (obj1, obj2) -> Bool in
                return obj1.saveTimeInMills > obj2.saveTimeInMills
            }
            return array
        }
        return []
    }
 
    func addKeyword(_ keyword: String) {
        var keywords: [KeywordModel] = getKeywords()
        keywords.removeAll(where: { $0.keyword == keyword })
        
        let keywordObj = KeywordModel(keyword: keyword, saveTimeInMills: Date().timeStamp)
        keywords.insert(keywordObj, at: 0)
        if keywords.count > maxKeywordLimit {
            keywords.removeLast()
        }
        Session.shared.setRecentSearchKeywords(keywords)
    }
    
    // 삭제기능 추후 고려
    func removeKeyword(_ keywordToRemove: String, completion: ((_ success: Bool) -> Void)?) {
        if var keywords = Session.shared.getRecentSearchKeywords() {
            keywords.removeAll(where: { $0.keyword == keywordToRemove })
            Session.shared.setRecentSearchKeywords(keywords)
            completion?(true)
        } else {
            completion?(false)
        }
    }
    
    func removeAllRecentKeyword(completion: (() -> Void)?) {
        Session.shared.setRecentSearchKeywords([])
        completion?()
    }
}
