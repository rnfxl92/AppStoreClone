//
//  SearchResultViewController.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import UIKit
import Combine

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

    typealias Delegates = SuggestedSearchTableViewAdapterDelegate & SearchResultViewAdapterDelegate
    typealias ViewModel = SuggestTableViewAdapterDataProvider
    & SearchResultCollectionViewAdapterDataProvider
    & SearchResultViewModel
    
    private weak var viewModel: ViewModel?
    private weak var delegate: Delegates?
    private var cancellables = Set<AnyCancellable>()
    private lazy var suggestTableViewAdapter = SuggestSearchTableViewAdapter(delegate: delegate, dataProvider: viewModel)
    private lazy var resultCollectionViewAdapter = SearchResultCollectionViewAdapter(delegate: delegate, dataProvider: viewModel)
    
    @IBOutlet private weak var suggestTableView: UITableView!
    @IBOutlet private weak var resultCollectionView: UICollectionView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
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
        indicatorView.isHidden = true
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
        case .indicatorView(let isShow):
            indicatorView.isHidden = !isShow
            isShow ? indicatorView.startAnimating() : indicatorView.stopAnimating()
        default:
            break
        }
    }
}
