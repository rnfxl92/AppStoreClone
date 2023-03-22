//
//  SuggestTableViewCell.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/19.
//

import UIKit

final class SuggestTableViewCell: UITableViewCell {

    
    @IBOutlet private weak var keywordLabel: UILabel!
    @IBOutlet private weak var magnifyingGlassImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func configure(keyword: String) {
        keywordLabel.text = keyword
    }
    
    private func setupView() {
        magnifyingGlassImageView.image = UIImage(
            systemName: "magnifyingglass")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    }
}
