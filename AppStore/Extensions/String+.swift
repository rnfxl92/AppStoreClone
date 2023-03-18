//
//  String+.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import Foundation

extension String {
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
}
