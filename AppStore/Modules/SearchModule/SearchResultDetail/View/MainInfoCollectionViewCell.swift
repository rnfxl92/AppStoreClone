//
//  MainInfoCollectionViewCell.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/21.
//

import UIKit
import SDWebImage

final class MainInfoCollectionViewCell: UICollectionViewCell {
    struct ViewModel {
        let appName: String
        let appImageUrlString: String
        let description: String?
        let formattedPrice: String?
        let price: Double // 가격
    }
    
    @IBOutlet private weak var appIconImageView: UIImageView!
    @IBOutlet private weak var appNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var downloadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func configure(with viewModel: ViewModel) {
        appIconImageView.sd_setImage(
            with: URL(string: viewModel.appImageUrlString),
            placeholderImage: UIImage(systemName: "app.gift.fill")
        )
        appNameLabel.text = viewModel.appName
        descriptionLabel.text = viewModel.description
        
        downloadButton.setTitle(viewModel.price == 0 ? "받기" : viewModel.formattedPrice, for: .normal)
    }

}

private extension MainInfoCollectionViewCell {
    func setupView() {
        downloadButton.setCornerRadius(15)
        appIconImageView.setCornerRadius(20, borderWidth: 1, borderColor: .systemGray5)
    }
}
