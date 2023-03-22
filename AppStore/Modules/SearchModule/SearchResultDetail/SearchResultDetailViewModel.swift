//
//  SearchResultDetailViewModel.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/21.
//

import Foundation
import Combine

final class SearchResultDetailViewModel: SearchResultDetailDataProvider {
    
    enum ViewState {
        case reloadCollectionView
        case updateCollectionViewLayout
        case isShowNavBarAppIcon(isShow: Bool)
    }
    
    let data: SearchResultItemModel
    let viewState = PassthroughSubject<ViewState, Never>()
    let isShowNaviBarAppIcon = CurrentValueSubject<Bool, Never>(false)
    
    private var cancellables = Set<AnyCancellable>()

    init(data: SearchResultItemModel) {
        self.data = data
        bind()
    }
    
    private func bind() {
        isShowNaviBarAppIcon.sink { [weak self] isShow in
            self?.viewState.send(.isShowNavBarAppIcon(isShow: isShow))
        }
        .store(in: &cancellables)
    }
}
