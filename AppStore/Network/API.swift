//
//  API.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/20.
//

import Foundation
import Alamofire

final class API {
    static let shared = API()
    
    static var itunesURLComponents: URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "itunes.apple.com"
        return urlComponent
    }
    
    //https://itunes.apple.com/search?entity=software&term=
    func search(keyword: String, completion: @escaping (Bool, SearchResultModel?, AFError?) -> Void) {
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
            .responseDecodable(of: SearchResultModel.self) { response in
                switch response.result {
                case .success(let model):
                    completion(true, model, nil)
                case .failure(let error):
                    completion(false, nil, error)
                }
            }
    }
}

