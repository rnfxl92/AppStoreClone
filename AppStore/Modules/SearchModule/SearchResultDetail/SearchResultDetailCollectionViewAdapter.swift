//
//  SearchResultDetailCollectionViewAdapter.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/21.
//

import UIKit

protocol SearchResultDetailDataProvider: AnyObject {
    var data: SearchResultItemModel { get }
}

final class SearchResultDetailCollectionViewAdapter: NSObject {
    typealias Delegates = DescriptionCollectionViewCellDelegate
   
    enum Section: Int, CaseIterable {
        case mainInfo
        case subInfo
        case screenShot
        case description
        case ratingAndReview
        case newFunction
        case InfoList
    }
    
    private enum Constant {
        static let itemMargin: CGFloat = 8
        static let sectionMargin: CGFloat = 16
    }
    
    private weak var delegate: Delegates?
    private weak var dataProvider: SearchResultDetailDataProvider?
    
    init(delegate: Delegates?, dataProvider: SearchResultDetailDataProvider?) {
        self.delegate = delegate
        self.dataProvider = dataProvider
    }
    
    func setRequirements(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = makeCompositionalLayout()
        
        collectionView.registerCellXib(cellClass: MainInfoCollectionViewCell.self)
        collectionView.registerCellXib(cellClass: SubInfoCollectionViewCell.self)
        collectionView.register(cellClass: ScreenShotCollectionViewCell.self)
        collectionView.registerCellXib(cellClass: DescriptionCollectionViewCell.self)
    }
    
}

private extension SearchResultDetailCollectionViewAdapter {
    func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection in
            
            switch Section(rawValue: sectionIndex) {
            case .mainInfo:
                return self.mainInfoSectionLayout()
            case .subInfo:
                return self.subInfoSectionLayout()
            case .screenShot:
                return self.screenShotSectionLayout()
            case .description:
                return self.descriptionSectionLayout()
            default:
                return self.mainInfoSectionLayout()
            }
        }
        return layout

    }
    
    func mainInfoSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.zero
        
        return section
    }
    
    func subInfoSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.zero
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: Constant.sectionMargin, leading: Constant.sectionMargin, bottom: Constant.sectionMargin, trailing: Constant.sectionMargin)
        
        return section
    }
    
    func screenShotSectionLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: Constant.itemMargin, leading: Constant.itemMargin, bottom: Constant.itemMargin, trailing: Constant.itemMargin)
        
        let width = floor((UIScreen.main.bounds.width - Constant.sectionMargin - Constant.itemMargin) / 1.5)
        let height = floor(width * 19.5 / 9)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.zero
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: Constant.sectionMargin, leading: Constant.sectionMargin, bottom: Constant.sectionMargin, trailing: Constant.sectionMargin)
        
        return section
    }
    
    func descriptionSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.zero
        section.contentInsets = .init(top: Constant.sectionMargin, leading: Constant.sectionMargin, bottom: Constant.sectionMargin, trailing: Constant.sectionMargin)
        return section
    }
}


extension SearchResultDetailCollectionViewAdapter: UICollectionViewDelegate {
    
}

extension SearchResultDetailCollectionViewAdapter: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .mainInfo, .subInfo, .description:
            return 1
        case .screenShot:
            return dataProvider?.data.screenshotUrls.count ?? .zero
        default:
            return .zero
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch Section(rawValue: indexPath.section) {
        case .mainInfo:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainInfoCollectionViewCell.className(), for: indexPath) as? MainInfoCollectionViewCell else {
                fatalError("Fail to dequeue MainInfoCollectionViewCell")
            }
            if let data = dataProvider?.data {
                cell.configure(
                    with: .init(
                        appName: data.trackName,
                        appImageUrlString: data.artworkUrl100,
                        description: data.resultDescription.components(separatedBy: "\n").first,
                        formattedPrice: data.formattedPrice,
                        price: data.price ?? 0)
                )
            }
            return cell
            
        case .subInfo:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubInfoCollectionViewCell.className(), for: indexPath) as? SubInfoCollectionViewCell else {
                fatalError("Fail to dequeue SubInfoCollectionViewCell")
            }
            if let data = dataProvider?.data {
                cell.configure(
                    with: .init(
                        userRatingCount: data.userRatingCount,
                        averageUserRating: data.averageUserRating,
                        contentAdvisoryRating: data.contentAdvisoryRating,
                        sellerName: data.sellerName,
                        languageCodesISO2A: data.languageCodesISO2A)
                )
            }

            return cell
        case .screenShot:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenShotCollectionViewCell.className(), for: indexPath) as? ScreenShotCollectionViewCell else {
                fatalError("Fail to dequeue ScreenShotCollectionViewCell")
            }
            if let data = dataProvider?.data,
               let imageUrlString = data.screenshotUrls[safe: indexPath.item] {
                cell.configure(urlString: imageUrlString)
            }
            return cell
        case .description:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCollectionViewCell.className(), for: indexPath) as? DescriptionCollectionViewCell else {
                fatalError("Fail to dequeue DescriptionCollectionViewCell")
            }
            if let data = dataProvider?.data,
               let delegate {
                cell.configure(with: data.resultDescription, delegate: delegate)
            }
            return cell
        default:
            break
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainInfoCollectionViewCell.className(), for: indexPath) as? MainInfoCollectionViewCell else {
            fatalError("Fail to dequeue MainInfoCollectionViewCell")
        }
        
        return cell
    }
}
