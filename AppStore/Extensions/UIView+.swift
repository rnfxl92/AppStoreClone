//
//  UIView+.swift
//  AppStore
//
//  Created by 박성민 on 2023/03/21.
//

#if os(iOS)
import UIKit

public extension UIView {
    func hideAndDisable(disable: Bool) {
        self.isHidden = disable
        self.isUserInteractionEnabled = !disable
    }
    
    func disableScrollsToTopPropertyOnAllSubViews() {
        for view in self.subviews {
            if view.isKind(of: UIScrollView.self) {
                if let scroll = view as? UIScrollView {
                    scroll.scrollsToTop = false
                }
            }
        }
    }
    
    func setBorder(_ width: CGFloat, color: UIColor?) {
        self.layer.borderWidth = width
        self.layer.borderColor = color?.cgColor
    }
    
    func removeBorder() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    func setCornerRadius(_ radius: CGFloat) {
        self.setCornerRadius(radius, borderWidth: 0.0, borderColor: nil)
    }
    
    func setCornerRadius(_ radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor?) {
        if let _ = borderColor {
            self.layer.borderColor = borderColor?.cgColor
            self.layer.borderWidth = borderWidth
        }
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    func setBorderStyle(width: CGFloat?, color: UIColor?, radius: CGFloat?) {
        if let width = width {
            self.layer.borderWidth = width
        }
        if let color = color {
            self.layer.borderColor = color.cgColor
        }
        if let radius = radius {
            self.layer.cornerRadius = radius
        }
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        self.layer.cornerRadius = radius
        var cornerMask = CACornerMask()
        if corners.contains(.topLeft) { cornerMask.insert(.layerMinXMinYCorner) }
        if corners.contains(.topRight) { cornerMask.insert(.layerMaxXMinYCorner) }
        if corners.contains(.bottomLeft) { cornerMask.insert(.layerMinXMaxYCorner) }
        if corners.contains(.bottomRight) { cornerMask.insert(.layerMaxXMaxYCorner) }
        self.layer.maskedCorners = cornerMask
    }
      
    func removeSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}

#endif

