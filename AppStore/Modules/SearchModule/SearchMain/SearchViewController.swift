//
//  SearchViewController.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {
    
    private let searchResultViewController = SearchResultViewController.initFromNib()
    private let viewModel = SearchViewModel()
    private lazy var recentSearchAdapter = RecentSearchAdapter(dataProvider: viewModel, delegate: self)
    private lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: searchResultViewController)
//        searchResultVC.detailAppDelegate = self
        searchController.searchBar.placeholder = "search.placeholder".localized()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet private weak var recentSearchCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
}

private extension SearchViewController {
    func setupView() {
        setupNavigationBar()
        recentSearchAdapter.setRequirements(recentSearchCollectionView)
        bind()
        viewModel.getRecentKeywords()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "search.title".localized()
        navigationItem.searchController = searchController
    }
    
    func bind() {
       
        
    }
    
    func render(_ state: SearchViewModel.ViewState) {
        switch state {
        case .reloadCollectionView:
            recentSearchCollectionView.reloadData()
        }
    }
}

extension SearchViewController: RecentSearchAdapterDelegate {
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let keyword = searchBar.text
        , keyword.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty else { return }

        viewModel.setRecentKeywords(keyword)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText.send(searchText)
    }
    
}

extension SearchViewController: UISearchControllerDelegate {
    
}
