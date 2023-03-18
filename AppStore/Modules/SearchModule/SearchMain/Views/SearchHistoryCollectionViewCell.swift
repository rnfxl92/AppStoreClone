//
//  SearchHistoryCollectionViewCell.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import UIKit

final class SearchHistoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var historyLabel: UILabel!
    @IBOutlet private weak var dividerView: UIView!
    
    func configure(history: String, hideDivider: Bool = false) {
        historyLabel.text = history
        dividerView.isHidden = hideDivider
    }

}
