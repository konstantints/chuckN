//
//  Appearance.swift
//  ChuckN
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Chipp Studio. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor
extension UIColor {
    @nonobjc class var background: UIColor {
        if UserDefaults.standard.bool(forKey: "dark") {
            return UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 31 / 255.0, alpha: 1.0)
        }
        
        return UIColor.white
    }
    
    @nonobjc class var themeButton: UIColor {
        if UserDefaults.standard.bool(forKey: "dark") {
            return UIColor(red: 222 / 255.0, green: 223 / 255.0, blue: 223 / 255.0, alpha: 1.0)
        }
        
        return UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 31 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var main: UIColor {
        return UIColor(red: 106.0 / 255.0, green: 130.0 / 255.0, blue: 150.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var title: UIColor {
        return UIColor(red: 241 / 255.0, green: 90 / 255.0, blue: 36 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var text: UIColor {
        if UserDefaults.standard.bool(forKey: "dark") {
            return UIColor(red: 222 / 255.0, green: 223 / 255.0, blue: 223 / 255.0, alpha: 1.0)
        }
        return UIColor(red: 22.0 / 255.0, green: 38.0 / 255.0, blue: 46.0 / 255.0, alpha: 1.0)
    }
}

// MARK: - UIView
extension UIView {
    func didUpdatedAppearance(animated: Bool) {
        for v in self.subviews {
            if let controller = v.parentViewController {
                controller.updateAppearance(animated: animated)
            }
            v.didUpdatedAppearance(animated: animated)
        }
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

// MARK: - UIViewController
extension UIViewController {
    @objc public func updateAppearance(animated: Bool) {
        for v in self.children {
            v.updateAppearance(animated: animated)
        }
    }
}
