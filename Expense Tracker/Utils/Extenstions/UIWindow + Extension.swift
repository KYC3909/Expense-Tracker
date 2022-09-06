//
//  UIWindow + Extension.swift
//  Expense Tracker
//
//  Created by Krunal on 6/9/22.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 15, *) {
            return UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }
}
