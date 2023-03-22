//
//  MockSearchRepository.swift
//  AppStoreTests
//
//  Created by 박성민 on 2023/03/22.
//

import Foundation
import Alamofire
@testable import AppStore

final class MockSearchRepository: SearchRepositoryProtocol {
    func search(keyword: String, completion: @escaping (Bool, SearchResultResponse?, ResponseError?) -> Void) {
        guard let data = load(name: keyword) else { return }
        let jsonDecoder = JSONDecoder()
        
        do {
            let searchResultResponse = try jsonDecoder.decode(SearchResultResponse.self, from: data)
            completion(true, searchResultResponse, nil)
        } catch {
            completion(false, nil, .decodingFail)
        }
    }
    
    private func load(name: String) -> Data? {
        let extensionType = "json"
        guard let fileLocation = Bundle(for: MockSearchRepository.self).path(forResource: name, ofType: extensionType) else { return nil }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: fileLocation), options: .mappedIfSafe)
            return jsonData
        } catch {
            return nil
        }
    }
}
