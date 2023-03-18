//
//  AnyNameable.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import Foundation

public protocol AnyNameable {
    static func className() -> String
}

public extension AnyNameable {
    static func className() -> String {
        return String(describing: self)
    }
}

extension NSObject: AnyNameable {}
