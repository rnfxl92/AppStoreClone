//
//  ScreenShotCollectionViewCell.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/22.
//

import UIKit
import SDWebImage

final class ScreenShotCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setCornerRadius(20, borderWidth: 1, borderColor: .systemGray4)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(urlString: String) {
        imageView.sd_setImage(with: URL(string: urlString))
    }
    
}
