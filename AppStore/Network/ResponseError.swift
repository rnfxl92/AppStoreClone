//
//  SearchError.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/22.
//

import Foundation

enum ResponseError: Error {
    case decodingFail
    case serverMessage(_ message: String)
    
    var errorDescription: String? {
        switch self {
        case .decodingFail:
            return "디코딩에 실패하였습니다."
        case .serverMessage(let message):
            return message
        }
    }
}
