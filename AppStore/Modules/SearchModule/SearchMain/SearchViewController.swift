//
//  SearchViewController.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {
   
    private let viewModel = SearchViewModel(repository: SearchRepository())
    private lazy var searchResultViewController = SearchResultViewController.initialize(viewModel: viewModel, delegate: self)
    private lazy var recentSearchAdapter = RecentSearchAdapter(dataProvider: viewModel, delegate: self)
    private lazy var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.autocapitalizationType = .none
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
}

private extension SearchViewController {
    func setupView() {
        
        recentSearchAdapter.setRequirements(recentSearchCollectionView)
        bind()
        viewModel.getRecentKeywords()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "search.title".localized()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func bind() {
        viewModel
            .viewState
            .sink {[weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
    }
    
    func render(_ state: SearchViewModel.ViewState) {
        switch state {
        case .reloadRecentSearchCollectionView:
            recentSearchCollectionView.reloadData()
        case .showAlert(let message):
            showAlertWithSingleConfirmButton(message: message, completion: nil)
        default:
            break
        }
    }
    
    func showAlertWithSingleConfirmButton(message: String?, completion: (() -> Void)?) {
        var defaultMessage = "Unknwon Error"
        if let message {
            defaultMessage = message
        }
        
        let alert = UIAlertController(title: "alert".localized(), message: defaultMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "confirm".localized(), style: .cancel, handler:
            { action in
                completion?()
            }
        )
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension SearchViewController: RecentSearchAdapterDelegate {
    func didSelectRecentSearch(keyword: String) {
        searchController.searchBar.text = keyword
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.resignFirstResponder()
        viewModel.requestSearch(keyword)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let keyword = searchBar.text
        , keyword.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty else { return }

        viewModel.requestSearch(keyword)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchCancel()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText.send(searchText)
    }
     
}

extension SearchViewController: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
    }
}

extension SearchViewController: SearchResultViewAdapterDelegate {
    func didSelectSearchResult(indexPath: IndexPath) {
        if let data = viewModel.searchResult[safe: indexPath.item],
           let vc = SearchResultDetailViewController.initialize(viewModel: .init(data: data)) {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension SearchViewController: SuggestedSearchTableViewAdapterDelegate {
    func didSelectSuggestedSearch(keyword: String) {
        searchController.searchBar.text = keyword
        searchController.searchBar.resignFirstResponder()
        viewModel.requestSearch(keyword)
    }
}
