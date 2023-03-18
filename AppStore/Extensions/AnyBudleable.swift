//
//  AnyBudleable.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

import Foundation

public protocol AnyBundleable {
    
    static var bundle: Bundle { get }
    
    var bundle: Bundle { get }
    
}

public extension AnyBundleable where Self: NSObject {
    
    static var bundle: Bundle { Bundle(for: self) }
    
    var bundle: Bundle { Bundle(for: type(of: self)) }
    
}

extension NSObject: AnyBundleable {}
