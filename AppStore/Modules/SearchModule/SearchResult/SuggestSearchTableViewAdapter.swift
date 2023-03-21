//
//  SuggestTableViewAdapter.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/19.
//

import UIKit
import Combine

protocol SuggestTableViewAdapterDataProvider: AnyObject {
    var suggestKeywords: [KeywordModel] { get }
}

protocol SuggestedSearchTableViewAdapterDelegate: AnyObject {
    func didSelectSuggestedSearch(keyword: String)
}

final class SuggestSearchTableViewAdapter: NSObject {
    
    private weak var delegate: SuggestedSearchTableViewAdapterDelegate?
    private weak var dataProvider: SuggestTableViewAdapterDataProvider?
    
    init(delegate: SuggestedSearchTableViewAdapterDelegate?, dataProvider: SuggestTableViewAdapterDataProvider?) {
        self.delegate = delegate
        self.dataProvider = dataProvider
    }
    
    func setRequirements(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCellXib(cellClass: SuggestTableViewCell.self)
    }
}

extension SuggestSearchTableViewAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let keyword = dataProvider?.suggestKeywords[safe: indexPath.item]?.keyword {
            delegate?.didSelectSuggestedSearch(keyword: keyword)
        }
    }
}

extension SuggestSearchTableViewAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider?.suggestKeywords.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SuggestTableViewCell.className(), for: indexPath) as? SuggestTableViewCell else {
            fatalError("Unable to dequeue SuggestTableViewCell")
        }
        
        if let keyword = dataProvider?.suggestKeywords[safe: indexPath.item]?.keyword  {
            cell.configure(keyword: keyword)
        }
            
        return cell
    }
}
