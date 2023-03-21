//
//  SearchResultDetailViewController.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/21.
//

import UIKit
import SDWebImage

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
        }
        return UIBarButtonItem(customView: button)
    }()
    
    lazy var isHiddenNavigationBarAppInfo: Bool = true { // TODO: - 스크롤링 받아서 처리하기
        didSet {
            if oldValue == isHiddenNavigationBarAppInfo {
                return
            }
            
            navigationAppView.isHidden = isHiddenNavigationBarAppInfo
            navigationButton.customView?.isHidden = isHiddenNavigationBarAppInfo
        }
    }
    
    private var viewModel: SearchResultDetailViewModel?
    private lazy var collectionViewAdapter = SearchResultDetailCollectionViewAdapter(delegate: self, dataProvider: viewModel)
    
    @IBOutlet private weak var mainCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViewNavigationBar()
    }

}

extension SearchResultDetailViewController {
    func setupView() {
        
        collectionViewAdapter.setRequirements(mainCollectionView)
        
    }
    
    func setupViewNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.titleView?.isHidden = isHiddenNavigationBarAppInfo
    }
}

extension SearchResultDetailViewController: DescriptionCollectionViewCellDelegate {
    func updateCollectionViewLayout() {
        mainCollectionView.collectionViewLayout.invalidateLayout()
    }
}
