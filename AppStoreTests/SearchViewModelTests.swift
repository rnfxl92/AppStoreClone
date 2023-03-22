//
//  SearchViewModelTests.swift
//  AppStoreTests
//
//  Created by 박성민 on 2023/03/22.
//

import XCTest
@testable import AppStore

final class SearchViewModelTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var session: Session!
    private var searchViewModel: SearchViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()

        userDefaults = UserDefaults(suiteName: #file)
        session = Session(userDefaults: userDefaults)
        searchViewModel = SearchViewModel(repository: MockSearchRepository())
    }

    override func tearDownWithError() throws {
        session = nil
        userDefaults = nil
        searchViewModel = nil
    
        try super.tearDownWithError()
    }

    func test_추천검색어_갯수1_테스트() throws {
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
        searchViewModel.getRecentKeywords()
        searchViewModel.searchText.send("첫번째")
        
        // THEN
        XCTAssertEqual(searchViewModel.suggestKeywords.count, 1)
    }
    
    func test_추천검색어_갯수2_테스트() throws {
        // GIVEN
        let test1 = "첫번째 테스트"
        let test2 = "두번째 테스트"
        let test3 = "세번째 테스트"
        let test4 = "네번째 테스트"
        let test5 = "카카오뱅크"
        let test6 = "카카오맵"
        
        RecentSearchKeywordManager.shared.removeAllRecentKeyword(completion: nil)
        RecentSearchKeywordManager.shared.addKeyword(test1)
        RecentSearchKeywordManager.shared.addKeyword(test2)
        RecentSearchKeywordManager.shared.addKeyword(test3)
        RecentSearchKeywordManager.shared.addKeyword(test4)
        RecentSearchKeywordManager.shared.addKeyword(test5)
        RecentSearchKeywordManager.shared.addKeyword(test6)
        
        // WHEN
        searchViewModel.getRecentKeywords()
        searchViewModel.searchText.send("카카오")
        
        // THEN
        XCTAssertEqual(searchViewModel.suggestKeywords.count, 2)
    }
    

    func test_Data_Decoding() throws {
        searchViewModel.requestSearch("카카오뱅크")
        
        XCTAssertGreaterThan(searchViewModel.searchResult.count, 0)
    }

}
