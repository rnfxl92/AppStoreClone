//
//  SearchViewController.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import UIKit

final class SearchViewController: UIViewController {
    private let searchResultViewController = SearchResultViewController.initFromNib()
    private lazy var searchHistoryAdapter = SearchHistoryAdapter(dataProvider: nil, delegate: self)
    
    private lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: searchResultViewController)
//        searchResultVC.detailAppDelegate = self
        searchController.searchBar.placeholder = "search.placeholder".localized()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    @IBOutlet private weak var searchHistoryCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
}

private extension SearchViewController {
    func setupView() {
        setupNavigationBar()
        searchHistoryAdapter.setRequirements(searchHistoryCollectionView)
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "search.title".localized()
        navigationItem.searchController = searchController
    }
    
}

extension SearchViewController: SearchHistoryAdapterDelegate {
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
//        updateSearchHistory(query: searchText)
//        searchResultVC.searchItems(searchText: searchText)
    }
    
    func updateSearchHistory(query: String) {
//        if let row = searchHistory.firstIndex(of: query) {
//            searchHistory.remove(at: row)
//        }
//
//        if searchHistory.count >= 10 {
//            searchHistory.removeLast()
//        }
//
//        searchHistory.insert(query, at: 0)
//
//        UserDefaults.standard.set(searchHistory, forKey: historyQuerys)
//        historyCollectionView.reloadData()
    }
}

extension SearchViewController: UISearchControllerDelegate {
    
}
