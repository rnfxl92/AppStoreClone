//
//  NibInitable.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/18.
//

#if os(iOS)
import UIKit

public protocol NibInitable {
    static func initFromNib() -> Self?
    static func initFromNib(from bundle: Bundle) -> Self?
}

public extension NibInitable where Self: UIView {
    static func initFromNib() -> Self? {
        let xibName = String(describing: self)
        guard let _ = bundle.path(forResource: xibName, ofType: "nib") else { return nil }
        return bundle.loadNibNamed(xibName, owner: nil, options: nil)?.first as? Self
    }
    
    static func initFromNib(from bundle: Bundle) -> Self? {
        let xibName = String(describing: self)
        guard let _ = bundle.path(forResource: xibName, ofType: "nib") else { return nil }
        return bundle.loadNibNamed(xibName, owner: nil, options: nil)?.first as? Self
    }
}

public extension NibInitable where Self: UIViewController {
    static func initFromNib() -> Self? {
        let xibName = String(describing: self)
        return ((Self)(nibName: xibName, bundle: bundle))
    }
    
    static func initFromNib(from bundle: Bundle) -> Self? {
        let xibName = String(describing: self)
        return ((Self)(nibName: xibName, bundle: bundle))
    }
}

extension UIView: NibInitable {}
extension UIViewController: NibInitable {}
#endif

