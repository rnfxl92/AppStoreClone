//
//  SeachResultCollectionViewCell.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/20.
//

import UIKit
import SnapKit
import SDWebImage

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    static func calculateCellSize(availableWidth: CGFloat) -> CGSize {
        
        let infoContainerHeight: CGFloat = 80 // height: 상단 60 + spacing 20
        let screenShotImageHeight: CGFloat = (availableWidth - 40 - 16) / 3 * 19.5 / 9 // 요즘 폰 비율 9 : 19.5
        
        return CGSize(width: floor(availableWidth), height: floor(infoContainerHeight + screenShotImageHeight))
    }
    
    struct ViewModel {
        let artworkUrl60: String // 아이콘 이미지 url
        let averageUserRating: Double // 별점
        let screenshotUrls: [String] // 스크린샷
        let userRatingCount: Int // 별점 갯수
        let trackName: String // 앱 이름
        let genres: [String] // 서브 타이틀
        let formattedPrice: String
        let price: Double // 가격
        
        var roundedaverageUserRating: Double {
            return (averageUserRating * 2).rounded() / 2 // 0.5 단위로 반올림
        }
        
        var subTitle: String {
            genres.joined(separator: ", ")
        }
    }

    private enum Constant {
        static let imageCornerRadius: CGFloat = 12
        static let downloadButtonCornerRadius: CGFloat = 15
        static let starImageWidth: CGFloat = 10
        static let imageBorderWidth: CGFloat = 1
        static let imageBorderColor: UIColor = .systemGray5
    }
    
    private lazy var ratingCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        
        return label
    }()
    
    @IBOutlet private weak var appNameLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var appIconImageView: UIImageView!
    @IBOutlet private weak var downloadButton: UIButton!
    @IBOutlet private weak var ratingStackView: UIStackView!
    @IBOutlet private var screenShotImageViews: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    func configure(with viewModel: ViewModel) {
        appIconImageView.sd_setImage(
            with: URL(string: viewModel.artworkUrl60),
            placeholderImage: UIImage(systemName: "app.gift.fill")
        )
        appNameLabel.text = viewModel.trackName
        subTitleLabel.text = viewModel.subTitle
        
        configureRating(rating: viewModel.roundedaverageUserRating, counts: viewModel.userRatingCount)
        
        for i in 0..<screenShotImageViews.count {
            if let urlString = viewModel.screenshotUrls[safe: i] {
                screenShotImageViews[safe: i]?.sd_setImage(with: URL(string: urlString))
            }
        }
        
        downloadButton.setTitle(viewModel.price == 0 ? "받기" : viewModel.formattedPrice, for: .normal)
    }

}

private extension SearchResultCollectionViewCell {
    
    func setupView() {
        appIconImageView.setBorderStyle(width: Constant.imageBorderWidth, color: Constant.imageBorderColor, radius: Constant.imageCornerRadius)
        downloadButton.setCornerRadius(Constant.downloadButtonCornerRadius)
        screenShotImageViews.forEach {
            $0.setBorderStyle(width: Constant.imageBorderWidth, color: Constant.imageBorderColor, radius: Constant.imageCornerRadius)
        }
    }
    
    func configureRating(rating: Double, counts: Int) {
        ratingStackView.removeSubviews()
        
        (0..<Int(rating)).forEach { _ in
            let fullStarImageView = UIImageView(image: UIImage(systemName: "star.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal))
            ratingStackView.insertArrangedSubview(fullStarImageView, at: ratingStackView.subviews.count)
                ratingStackView.addArrangedSubview(fullStarImageView)
            fullStarImageView.snp.makeConstraints {
                $0.width.height.equalTo(Constant.starImageWidth)
            }
        }
        if (rating != floor(rating)) {
            let halfStarImageView = UIImageView(image: UIImage(systemName: "star.leadinghalf.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal))
            ratingStackView.addArrangedSubview(halfStarImageView)
            halfStarImageView.snp.makeConstraints {
                $0.width.height.equalTo(Constant.starImageWidth)
            }
        }
        
        (0..<Int((5.0 - rating))).forEach { _ in
            let emptyStarImageView = UIImageView(image: UIImage(systemName: "star")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal))
                ratingStackView.addArrangedSubview(emptyStarImageView)
            emptyStarImageView.snp.makeConstraints {
                $0.width.height.equalTo(Constant.starImageWidth)
            }
        }
        ratingCountLabel.text = counts.countText()
        ratingStackView.addArrangedSubview(ratingCountLabel)
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
