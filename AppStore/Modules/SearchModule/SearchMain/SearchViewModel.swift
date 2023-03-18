//
//  SearchViewModel.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import Foundation
import Combine

final class SearchViewModel {
    
    enum ViewState {
        case reloadCollectionView
    }
    
    let viewState = PassthroughSubject<ViewState, Never>()
    let searchText = PassthroughSubject<String, Never>()
    private let recentSearchKeywords = CurrentValueSubject<[KeywordModel], Never>([])
    
    private var cancellables = Set<AnyCancellable>()
    
    func getRecentKeywords() {
        recentSearchKeywords.send(RecentSearchKeywordManager.shared.getKeywords())
    }
    
    func setRecentKeywords(_ keyword: String) {
        RecentSearchKeywordManager.shared.addKeyword(keyword)
    }
}

private extension SearchViewModel {
    func bind() {
        recentSearchKeywords.sink { [weak self] _ in
            self?.viewState.send(.reloadCollectionView)
        }
        .store(in: &cancellables)
    }
}

extension SearchViewModel: RecentSearchAdapterDataProvider {
    var recentKeywords: [KeywordModel] {
        recentSearchKeywords.value
    }
}


