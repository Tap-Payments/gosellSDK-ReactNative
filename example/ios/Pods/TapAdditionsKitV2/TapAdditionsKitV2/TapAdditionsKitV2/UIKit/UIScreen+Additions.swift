//
//  UIScreen+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class	UIKit.UIScreen

/// Useful extension for UIScreen class.
public extension UIScreen {
    
    // MARK: - Public -
    // MARK: Properties

    /// Returns number of points in one pixel.
    var tap_numberOfPointsInOnePixel: CGFloat {
        
        return 1.0 / self.scale
    }
}
