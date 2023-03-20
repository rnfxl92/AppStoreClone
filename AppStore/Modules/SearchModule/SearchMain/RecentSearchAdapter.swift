//
//  RecentSearchAdapter.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import UIKit

protocol RecentSearchAdapterDelegate: AnyObject {
    func didSelectRecentSearch(keyword: String)
}

protocol RecentSearchAdapterDataProvider: AnyObject {
    var recentKeywords: [KeywordModel] { get }
}

final class RecentSearchAdapter: NSObject {
    
    private weak var dataProvider: RecentSearchAdapterDataProvider?
    private weak var delegate: RecentSearchAdapterDelegate?
    
    init(dataProvider: RecentSearchAdapterDataProvider?, delegate: RecentSearchAdapterDelegate?) {
        self.dataProvider = dataProvider
        self.delegate = delegate
    }
    
    func setRequirements(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerCellXib(cellClass: SearchHistoryCollectionViewCell.self)
        collectionView.registerCellXib(cellClass: EmptyStateCollectionViewCell.self)
        collectionView.registerViewXib(viewClass: RecentHeaderView.self, supplement: .header)
    }
    
}

extension RecentSearchAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let keyword = dataProvider?.recentKeywords[safe: indexPath.item]?.keyword {
            delegate?.didSelectRecentSearch(keyword: keyword)
        }
    }
}

extension RecentSearchAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider?.recentKeywords.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let dataProvider,
              dataProvider.recentKeywords.isNotEmpty
        else {
            guard let cell = collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: EmptyStateCollectionViewCell.className(),
                    for: indexPath) as? EmptyStateCollectionViewCell else {
                fatalError("Unable to dequeue EmptyStateCollectionViewCell")
            }
            
            cell.configure(.searchHistory)
        
            return cell
        }
          
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: SearchHistoryCollectionViewCell.className(),
                for: indexPath) as? SearchHistoryCollectionViewCell else {
            fatalError("Unable to dequeue SearchHistoryCollectionViewCell")
        }
        if let keyword = dataProvider.recentKeywords[safe: indexPath.item]?.keyword {
            cell
                .configure(
                    history: keyword,
                    hideDivider: dataProvider.recentKeywords.count - 1 == indexPath.item
                )
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplement = SectionSupplement(rawValue: kind)
        
        switch supplement {
        case .header:
            guard let header = collectionView
                .dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: RecentHeaderView.className(),
                    for: indexPath) as?  RecentHeaderView else {
                fatalError("Unable to dequeue RecentHeaderView")
            }
            return header
        default:
            return .init()
        }
    }

}

extension RecentSearchAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            if dataProvider?.recentKeywords.isNotEmpty ?? false {
                return CGSize(width: collectionView.bounds.width, height: 40)
            } else { // Empty Case
                return CGSize(width: collectionView.bounds.width, height: 200)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if dataProvider?.recentKeywords.isNotEmpty ?? false {
            return CGSize(width: collectionView.bounds.width, height: 60)
        }
        return .zero
    }
}

