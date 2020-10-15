//
//  UIWindow+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIApplication.UIApplication
import class	UIKit.UIWindow.UIWindow

/// Useful UIWindow extension.
public extension UIWindow {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns closest higher window in hierarch (if found).
    var tap_closestHigherWindow: UIWindow? {
        
        let level = UIWindow.Level.tap_minimalAmongPresented(higher: self.windowLevel)
        guard level != self.windowLevel else { return nil }
        
        return type(of: self).tap_with(level)
    }
    
    /// Returns closest lower window in hierarchy (if found).
    var tap_closestLowerWindow: UIWindow? {
        
        let level = UIWindow.Level.tap_maximalAmongPresented(lower: self.windowLevel)
        guard level != self.windowLevel else { return nil }
        
        return type(of: self).tap_with(level)
    }

    // MARK: - Private -
    // MARK: Methods
    
    private static func tap_with(_ level: UIWindow.Level) -> UIWindow? {
        
        return UIApplication.shared.windows.filter { $0.windowLevel == level }.first
    }
}
