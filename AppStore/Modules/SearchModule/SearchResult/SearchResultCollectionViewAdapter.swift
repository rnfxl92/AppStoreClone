//
//  SearchResultCollectionViewAdapter.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/21.
//

import UIKit

protocol SearchResultCollectionViewAdapterDataProvider: AnyObject {
    var searchResult: [SearchResultItemModel] { get }
}

protocol SearchResultViewAdapterDelegate: AnyObject {
    func  didSelectSearchResult(indexPath: IndexPath)
}

final class SearchResultCollectionViewAdapter: NSObject {
    
    private weak var dataProvider: SearchResultCollectionViewAdapterDataProvider?
    private weak var delegate: SearchResultViewAdapterDelegate?
    
    init(delegate: SearchResultViewAdapterDelegate?, dataProvider: SearchResultCollectionViewAdapterDataProvider?) {
        self.delegate = delegate
        self.dataProvider = dataProvider
    }
    
    func setRequirements(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerCellXib(cellClass: SearchResultCollectionViewCell.self)
    }
}

extension SearchResultCollectionViewAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectSearchResult(indexPath: indexPath)
    }
}

extension SearchResultCollectionViewAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider?.searchResult.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.className(), for: indexPath) as? SearchResultCollectionViewCell else {
            fatalError("Unable to dequeue SearchResultCollectionViewCell")
        }
        
        if let data = dataProvider?.searchResult[safe: indexPath.item] {
            cell.configure(
                with: .init(
                    artworkUrl60: data.artworkUrl60,
                    averageUserRating: data.averageUserRating,
                    screenshotUrls: data.screenshotUrls,
                    userRatingCount: data.userRatingCount,
                    trackName: data.trackName,
                    genres: data.genres,
                    formattedPrice: data.formattedPrice ?? "",
                    price: data.price ?? 0)
            )
        }
  
        return cell
    }
}

extension SearchResultCollectionViewAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SearchResultCollectionViewCell.calculateCellSize(availableWidth: collectionView.bounds.size.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
}
