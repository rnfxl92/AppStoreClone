//
//  SearchViewModel.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import Foundation
import Combine

final class SearchViewModel: SearchResultViewModel {
    
    enum ViewState {
        case reloadCollectionView
        case hideSuggestTableView(isHidden: Bool)
        case reloadResultCollectionView
    }
    
    let viewState = PassthroughSubject<ViewState, Never>()
    let searchText = CurrentValueSubject<String, Never>("")
    private let recentSearchKeywords = CurrentValueSubject<[KeywordModel], Never>([])
    private var data: SearchResultModel?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    func getRecentKeywords() {
        recentSearchKeywords.send(RecentSearchKeywordManager.shared.getKeywords())
    }
    
    func requestSearch(_ keyword: String) {
        RecentSearchKeywordManager.shared.addKeyword(keyword)
        viewState.send(.hideSuggestTableView(isHidden: true))
        API.shared.search(keyword: keyword) { [weak self] success, data, error in
            if success,
               let data {
                self?.data = data
                self?.viewState.send(.reloadResultCollectionView)
            } else {
                // TODO: - 에러 처리
            }
        }
        
    }
}

private extension SearchViewModel {
    func bind() {
        recentSearchKeywords.sink { [weak self] _ in
            self?.viewState.send(.reloadCollectionView)
        }
        .store(in: &cancellables)
        
        searchText.sink { [weak self] _ in
            self?.viewState.send(.hideSuggestTableView(isHidden: false))
        }
        .store(in: &cancellables)
    }
}

extension SearchViewModel: RecentSearchAdapterDataProvider {
    var recentKeywords: [KeywordModel] {
        recentSearchKeywords.value
    }
}

extension SearchViewModel: SuggestTableViewAdapterDataProvider {
    var suggestKeywords: [KeywordModel] {
        recentSearchKeywords.value.filter { $0.keyword.contains(searchText.value)}
    }
}

extension SearchViewModel: SearchResultCollectionViewAdapterDataProvider {
    var searchResult: [SearchResultItemModel] {
        return data?.results ?? []
    }
}
