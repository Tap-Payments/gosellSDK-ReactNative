//
//  UIEdgeInsets+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import struct	UIKit.UIGeometry.UIEdgeInsets

/// Useful addition to UIEdgeInsets.
public extension UIEdgeInsets {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns mirrored result.
    var tap_mirrored: UIEdgeInsets {
        
        let original = self
        
        var result = self
        result.left = original.right
        result.right = original.left
        
        return result
    }
    
    // MARK: Methods
    
    /// Initializes UIEdgeInsets with the same insets from all sides.
    ///
    /// - Parameter inset: Inset.
    init(tap_inset: CGFloat) {
        
        self.init(top: tap_inset, left: tap_inset, bottom: tap_inset, right: tap_inset)
    }
}
