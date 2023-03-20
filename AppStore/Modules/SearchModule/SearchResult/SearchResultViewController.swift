//
//  SearchResultViewController.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import UIKit
import Combine

protocol SuggestedSearchDelegate: AnyObject {
    func didSelectSuggestedSearch(keyword: String)
}

protocol SearchResultViewControllerDelegate: AnyObject {
    
}

protocol SearchResultViewModel: AnyObject {
    var viewState: PassthroughSubject<SearchViewModel.ViewState, Never> { get }
}

final class SearchResultViewController: UIViewController {
    
    static func initialize(viewModel: ViewModel, delegate: Delegates) -> SearchResultViewController? {
        let vc = SearchResultViewController.initFromNib()
        vc?.viewModel = viewModel
        vc?.delegate = delegate
        
        return vc
    }

    typealias Delegates = SuggestedSearchDelegate & SearchResultViewControllerDelegate
    typealias ViewModel = SuggestTableViewAdapterDataProvider
    & SearchResultCollectionViewAdapterDataProvider
    & SearchResultViewModel
    
    private weak var viewModel: ViewModel?
    private weak var delegate: Delegates?
    private var cancellables = Set<AnyCancellable>()
    private lazy var suggestTableViewAdapter = SuggestTableViewAdapter(delegate: delegate, dataProvider: viewModel)
    private lazy var resultCollectionViewAdapter = SearchResultCollectionViewAdapter(dataProvider: viewModel)
    
    @IBOutlet private weak var suggestTableView: UITableView!
    @IBOutlet private weak var resultCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
    }
}

private extension SearchResultViewController {
    func setupView() {
        suggestTableViewAdapter.setRequirements(suggestTableView)
        resultCollectionViewAdapter.setRequirements(resultCollectionView)
    }
    
    func bind() {
        viewModel?.viewState.sink { [weak self] state in
            self?.render(state)
        }
        .store(in: &cancellables)
    }
    
    func render(_ viewState: SearchViewModel.ViewState) {
        switch viewState {
        case .hideSuggestTableView(let isHidden):
            suggestTableView.isHidden = isHidden
            suggestTableView.reloadData()
        case .reloadResultCollectionView:
            resultCollectionView.reloadData()
            resultCollectionView.setContentOffset(.zero, animated: false)
        default:
            break
        }
    }
}
