//
//  RecentHeaderView.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/19.
//

import UIKit

final class RecentHeaderView: UICollectionReusableView {

    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = "search.recent_searches".localized()
    }
    
}
