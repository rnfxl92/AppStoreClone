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
    enum Section: Int, CaseIterable {
        case mainInfo
        case subInfo
        case newFunction
        case screenShot
        case description
        case ratingAndReview
        case InfoList
    }
    
    private weak var dataProvider: SearchResultDetailDataProvider?
    
    init(dataProvider: SearchResultDetailDataProvider? = nil) {
        self.dataProvider = dataProvider
    }
    
    func setRequirements(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = makeCompositionalLayout()
        
        collectionView.registerCellXib(cellClass: MainInfoCollectionViewCell.self)
    }
    
}

private extension SearchResultDetailCollectionViewAdapter {
    func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection in
            
            switch Section(rawValue: sectionIndex) {
            case .mainInfo:
                return self.mainInfoSectionLayout()
                
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
    
}


extension SearchResultDetailCollectionViewAdapter: UICollectionViewDelegate {
    
}

extension SearchResultDetailCollectionViewAdapter: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
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
        default:
            break
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainInfoCollectionViewCell.className(), for: indexPath) as? MainInfoCollectionViewCell else {
            fatalError("Fail to dequeue MainInfoCollectionViewCell")
        }
        
        return cell
    }
}
