//
//  Date+.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/19.
//

import Foundation

extension Date {
    var timeStamp: Int64 {
        Int64(timeIntervalSince1970 * 1000)
    }
}
