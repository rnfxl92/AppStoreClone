//
//  SearchResultViewController.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import UIKit

protocol SuggestedSearch: AnyObject {
    func didSelectSuggestedSearch(keyword: String)
    
    // A product was selected; inform our delgeate that a product was selected to view.
//    func didSelectProduct(product: Product)
}

final class SearchResultViewController: UIViewController {

    
    @IBOutlet private weak var suggestTableView: UITableView!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    weak var suggestedSearchDelegate: SuggestedSearch?
    
  

}
