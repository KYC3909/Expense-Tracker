//
//  UIView + Extension.swift
//  Expense Tracker
//
//  Created by Krunal on 30/8/22.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.shadowRadius = newValue
            layer.masksToBounds = false
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            layer.shadowColor = UIColor.gray.cgColor
        }
    }
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            layer.shadowColor = UIColor.gray.cgColor
            layer.masksToBounds = false
        }
    }
}

enum CardViewType {
    case appstore
    case playstore
}

extension UIView {
    // Load CardView / DropShadow based on the type selected.
    /// Type: `.appstore`, `.playstore`
    func cardView(_ type: CardViewType) {
        switch type {
            case .appstore: dropShadowForAppStore()
            case .playstore: dropShadowForPlayStore()
        }
    }
    
    // Drop Shadow like `AppStore`
    private func dropShadowForAppStore(scale: Bool = true) {
        let shadowColor = UIColor(named: "ShadowColor")
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor ?? UIColor.gray.cgColor
        layer.shadowOpacity = shadowColor != nil ? 0.7 : 0.3
        layer.shadowOffset = .zero
        layer.cornerRadius = 20
        layer.shadowRadius = 12
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // Drop Shadow like `PlayStore`
    private func dropShadowForPlayStore(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor ?? UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.cornerRadius = 8
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

}
