//
//  SearchRepository.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/20.
//

import Foundation
import Alamofire

protocol SearchRepositoryProtocol {
    func search(keyword: String, completion: @escaping (Bool, SearchResultResponse?, ResponseError?) -> Void)
}

final class SearchRepository: SearchRepositoryProtocol {
    
    //https://itunes.apple.com/search?media=software&entity=software&term=
    func search(keyword: String, completion: @escaping (Bool, SearchResultResponse?, ResponseError?) -> Void) {
        let host = "https://itunes.apple.com"
        let path = "/search"
        let url = host + path
        let params: Parameters = [
            "media": "software",
            "entity": "software",
            "country": "search.country".localized(),
            "term" : keyword
        ]
        _ = AF
            .request(
                url,
                method: .get,
                parameters: params,
                encoding: URLEncoding.queryString
            )
            .responseDecodable(of: SearchResultResponse.self) { response in
                switch response.result {
                case .success(let model):
                    completion(true, model, nil)
                case .failure(let error):
                    completion(false, nil, .serverMessage(error.localizedDescription))
                }
            }
    }
}

