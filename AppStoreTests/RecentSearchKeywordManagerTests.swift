//
//  RecentSearchKeywordManagerTests.swift
//  AppStoreTests
//
//  Created by 박성민 on 2023/03/22.
//

import XCTest
@testable import AppStore

final class RecentSearchKeywordManagerTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var session: Session!
    
    override func setUpWithError() throws {
        try super.setUpWithError()

        userDefaults = UserDefaults(suiteName: #file)
        session = Session(userDefaults: userDefaults)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        session = nil
        userDefaults = nil
    }

    func test_키워드_추가_테스트() throws {
        // GIVEN
        RecentSearchKeywordManager.shared.removeAllRecentKeyword(completion: nil)
        
        // WHEN
        let testKeyword: String = "테스트"
        RecentSearchKeywordManager.shared.addKeyword(testKeyword)
        
        // THEN
        XCTAssertTrue(RecentSearchKeywordManager.shared.getKeywords().contains(where: {$0.keyword == testKeyword}))
    }

    func test_키워드_순서갱신_테스트() throws {
        // GIVEN
        let test1 = "첫번째 테스트"
        let test2 = "두번째 테스트"
        let test3 = "세번째 테스트"
        let test4 = "네번째 테스트"
        
        RecentSearchKeywordManager.shared.removeAllRecentKeyword(completion: nil)
        RecentSearchKeywordManager.shared.addKeyword(test1)
        RecentSearchKeywordManager.shared.addKeyword(test2)
        RecentSearchKeywordManager.shared.addKeyword(test3)
        RecentSearchKeywordManager.shared.addKeyword(test4)
        
        // WHEN
        RecentSearchKeywordManager.shared.addKeyword(test1)
        
        // THEN
        XCTAssertEqual(
            RecentSearchKeywordManager.shared.getKeywords().first?.keyword, test1,
            "첫번째 단어 테스트"
        )
        XCTAssertEqual(
            RecentSearchKeywordManager.shared.getKeywords().last?.keyword,
            test2,
            "마지막 단어 테스트"
        )

    }
    
    func test_키워드_제거_테스트() throws {
        // GIVEN
        RecentSearchKeywordManager.shared.removeAllRecentKeyword(completion: nil)
        
        let test1 = "첫번째 테스트"
        let test2 = "두번째 테스트"
        let test3 = "세번째 테스트"
        let test4 = "네번째 테스트"
        
        RecentSearchKeywordManager.shared.addKeyword(test1)
        RecentSearchKeywordManager.shared.addKeyword(test2)
        RecentSearchKeywordManager.shared.addKeyword(test3)
        RecentSearchKeywordManager.shared.addKeyword(test4)
        
        // WHEN
        RecentSearchKeywordManager.shared.removeKeyword(test3, completion: nil)
        
        // THEN
        print(RecentSearchKeywordManager.shared.getKeywords())
        XCTAssertNil(RecentSearchKeywordManager.shared.getKeywords().first(where: { $0.keyword == test3 }))
        
    }

}
