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
        case reloadRecentSearchCollectionView
        case hideSuggestTableView(isHidden: Bool)
//        case reloadSuggestTableView
        case reloadResultCollectionView
        case showAlert(message: String?)
        case indicatorView(isShow: Bool)
    }
    
    let viewState = PassthroughSubject<ViewState, Never>()
    let searchText = CurrentValueSubject<String, Never>("")
    private let recentSearchKeywords = CurrentValueSubject<[KeywordModel], Never>([])
    
    private var data: SearchResultModel?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    func searchCancel() {
        getRecentKeywords()
        viewState.send(.hideSuggestTableView(isHidden: false))
    }
    
    func getRecentKeywords() {
        recentSearchKeywords.send(RecentSearchKeywordManager.shared.getKeywords())
    }
    
    func requestSearch(_ keyword: String) {
        RecentSearchKeywordManager.shared.addKeyword(keyword)
        viewState.send(.hideSuggestTableView(isHidden: true))
        data = nil
        viewState.send(.reloadResultCollectionView)
        viewState.send(.indicatorView(isShow: true))
        
        Network.shared.search(keyword: keyword) { [weak self] success, data, error in
            self?.viewState.send(.indicatorView(isShow: false))
            if success,
               let data {
                self?.data = data
                self?.viewState.send(.reloadResultCollectionView)
                self?.getRecentKeywords()
            } else {
                self?.viewState.send(.showAlert(message: error?.localizedDescription))
            }
        }
        
    }
}

private extension SearchViewModel {
    func bind() {
        recentSearchKeywords.sink { [weak self] _ in
            self?.viewState.send(.reloadRecentSearchCollectionView)
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
