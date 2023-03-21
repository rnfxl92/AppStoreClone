//
//  SearchResultDetailViewController.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/21.
//

import UIKit

final class SearchResultDetailViewController: UIViewController {

    static func initialize(viewModel: SearchResultDetailViewModel) -> SearchResultDetailViewController? {
        let vc = SearchResultDetailViewController.initFromNib()
        vc?.viewModel = viewModel
        
        return vc
    }
    
    private var viewModel: SearchResultDetailViewModel?
    private lazy var collectionViewAdapter = SearchResultDetailCollectionViewAdapter(dataProvider: viewModel)
    
    @IBOutlet private weak var mainCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    
}

extension SearchResultDetailViewController {
    func setupView() {
        collectionViewAdapter.setRequirements(mainCollectionView)
    }
}
