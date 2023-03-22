//
//  SearchResultDetailViewController.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/21.
//

import UIKit
import SDWebImage
import Combine

final class SearchResultDetailViewController: UIViewController {

    static func initialize(viewModel: SearchResultDetailViewModel) -> SearchResultDetailViewController? {
        let vc = SearchResultDetailViewController.initFromNib()
        vc?.viewModel = viewModel
        
        return vc
    }
    
    private lazy var navigationAppView: UIView = {
        let uiView = UIView()
        uiView.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(64)
        }
        
        var iconView = UIImageView()
        if let viewModel {
            iconView.sd_setImage(with: URL(string: viewModel.data.artworkUrl60))
        }
        iconView.layer.cornerRadius = 10
        iconView.layer.masksToBounds = true
        iconView.contentMode = .scaleAspectFit

        uiView.addSubview(iconView)
        
        iconView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.center.equalTo(uiView)
        }
        return uiView
    }()
    
    private lazy var navigationButton: UIBarButtonItem = {
        let button = UIButton()
        button.backgroundColor = .link
        button.setTitle("search_result.down".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(30)
        }
        return UIBarButtonItem(customView: button)
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: SearchResultDetailViewModel?
    private lazy var collectionViewAdapter = SearchResultDetailCollectionViewAdapter(delegate: self, dataProvider: viewModel)
    
    @IBOutlet private weak var mainCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }

}

private extension SearchResultDetailViewController {
    func setupView() {
        collectionViewAdapter.setRequirements(mainCollectionView)
        navigationItem.rightBarButtonItems = [navigationButton]
        navigationItem.titleView = navigationAppView
    }
    
    func bind() {
        viewModel?.viewState.sink { [weak self] state in
            self?.render(state)
        }
        .store(in: &cancellables)
    }
    
    func render(_ viewState: SearchResultDetailViewModel.ViewState) {
        switch viewState {
        case .reloadCollectionView:
            mainCollectionView.reloadData()
        case .updateCollectionViewLayout:
            mainCollectionView.collectionViewLayout.invalidateLayout()
        case .isShowNavBarAppIcon(let isShow):
            navigationAppView.isHidden = !isShow
            navigationButton.customView?.isHidden = !isShow
        }
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.titleView?.isHidden = !(viewModel?.isShowNaviBarAppIcon.value ?? false)
    }
}

extension SearchResultDetailViewController: DescriptionCollectionViewCellDelegate {
    func updateCollectionViewLayout() {
        render(.updateCollectionViewLayout)
    }
}
