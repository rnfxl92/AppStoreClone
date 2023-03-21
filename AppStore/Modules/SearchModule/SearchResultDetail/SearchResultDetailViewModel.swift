//
//  SearchResultDetailViewModel.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/21.
//

import Foundation

final class SearchResultDetailViewModel: SearchResultDetailDataProvider {
    let data: SearchResultItemModel
    
    init(data: SearchResultItemModel) {
        self.data = data
    }
}
