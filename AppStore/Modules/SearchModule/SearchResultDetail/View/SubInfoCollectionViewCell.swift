//
//  SubInfoCollectionViewCell.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/21.
//

import UIKit

final class SubInfoCollectionViewCell: UICollectionViewCell {
    
    struct ViewModel {
        let userRatingCount: Int
        let averageUserRating: Double // 별점
        let contentAdvisoryRating: String // 연령
        let sellerName: String // 개발자
        let languageCodesISO2A: [String] // 언어
        var ratingText: String {
            String(format: "%.1f", averageUserRating)
        }
        var userRatingCountText: String {
            userRatingCount.countText() + "개의 평가"
        }
    }
    
    private enum Constant {
        static let starImageWidth: CGFloat = 15
    }
    
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var ratingCountLabel: UILabel!
    @IBOutlet private weak var ratingStackView: UIStackView!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var ageTitleLabel: UILabel!
    @IBOutlet private weak var developerTitleLabel: UILabel!
    @IBOutlet private weak var developerImageView: UIImageView!
    @IBOutlet private weak var developerLabel: UILabel!
    @IBOutlet private weak var languageTitleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var languageDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func configure(with viewModel: ViewModel) {
        ratingLabel.text = viewModel.ratingText
        ratingCountLabel.text = viewModel.userRatingCountText
        configureRatingStar(rating: viewModel.averageUserRating)
        ageLabel.text = viewModel.contentAdvisoryRating
        developerLabel.text = viewModel.sellerName
        if let lang = viewModel.languageCodesISO2A.first {
            languageLabel.text = lang
        } else {
            languageLabel.text = "KR"
        }
        if viewModel.languageCodesISO2A.count > 1 {
            languageDescriptionLabel.text = "+\(viewModel.languageCodesISO2A.count)개 언어"
        } else {
            languageDescriptionLabel.text = "입니다"
        }
    }
}

private extension SubInfoCollectionViewCell {
    
    func setupView() {
        ageTitleLabel.text = "age".localized()
        developerTitleLabel.text = "developer".localized()
        developerImageView.image = UIImage(systemName: "person.crop.square")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        languageTitleLabel.text = "language".localized()
        
    }
    
    func configureRatingStar(rating: Double) {
        for subview in ratingStackView.subviews {
            if subview.isKind(of: UIImageView.self) {
                subview.removeFromSuperview()
            }
        }
        
        (0..<Int(rating)).forEach { _ in
            let fullStarImageView = UIImageView(image: UIImage(systemName: "star.fill")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal))
            ratingStackView.insertArrangedSubview(fullStarImageView, at: ratingStackView.subviews.count)
                ratingStackView.addArrangedSubview(fullStarImageView)
            fullStarImageView.snp.makeConstraints {
                $0.width.height.equalTo(Constant.starImageWidth)
            }
        }
        if (rating != floor(rating)) {
            let halfStarImageView = UIImageView(image: UIImage(systemName: "star.leadinghalf.fill")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal))
            ratingStackView.addArrangedSubview(halfStarImageView)
            halfStarImageView.snp.makeConstraints {
                $0.width.height.equalTo(Constant.starImageWidth)
            }
        }
        
        (0..<Int((5.0 - rating))).forEach { _ in
            let emptyStarImageView = UIImageView(image: UIImage(systemName: "star")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal))
                ratingStackView.addArrangedSubview(emptyStarImageView)
            emptyStarImageView.snp.makeConstraints {
                $0.width.height.equalTo(Constant.starImageWidth)
            }
        }
    }
    
}

fileprivate extension Int {
    func countText() -> String {
        if self >= 10000 {
            let dividedByTenThousand = Double(self) / 10000.0
            return String(format: "%.1f만", dividedByTenThousand)
        } else if self >= 1000 {
            let dividedByThousand = Double(self) / 1000.0
            return String(format: "%.1f천", dividedByThousand)
        } else {
            return "\(self)"
        }
    }
}
