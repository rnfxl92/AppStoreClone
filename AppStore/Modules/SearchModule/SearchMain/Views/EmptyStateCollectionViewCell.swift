//
//  EmptyStateCollectionViewCell.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import UIKit

final class EmptyStateCollectionViewCell: UICollectionViewCell {

    enum EmptyCase {
        case searchHistory
        case search
        
        var description: String {
            switch self {
                
            case .searchHistory:
                return "search.history_empty".localized()
            case .search:
                return "search.empty".localized()
            }
        }
        
    }
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func configure(_ emptyCase: EmptyCase) {
        descriptionLabel.text = emptyCase.description
    }

}
