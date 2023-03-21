//
//  DescriptionCollectionViewCell.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/22.
//

import UIKit

protocol DescriptionCollectionViewCellDelegate: AnyObject {
    func updateCollectionViewLayout()
}

final class DescriptionCollectionViewCell: UICollectionViewCell {

    private weak var delegate: DescriptionCollectionViewCellDelegate?
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var moreButton: UIButton!
    
    func configure(with description: String, delegate: DescriptionCollectionViewCellDelegate) {
        descriptionLabel.text = description
        self.delegate = delegate
    }

    @IBAction private func moreButtonTouchUpInside(_ sender: Any) {
        descriptionLabel.numberOfLines = 0
        moreButton.isHidden = true
        delegate?.updateCollectionViewLayout()
    }
}
