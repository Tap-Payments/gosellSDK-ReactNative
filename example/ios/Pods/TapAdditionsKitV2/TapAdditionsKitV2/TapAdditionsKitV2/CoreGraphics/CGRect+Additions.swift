//
//  CGRect+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics

/// Useful additions for CGRect.
public extension CGRect {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns ceiled rect with integer origin and size.
    var tap_ceiled: CGRect {
        
        return CGRect(origin: self.origin.tap_floored, size: self.size.tap_ceiled)
    }
    
    /// Returns floored rect with integer origin and size.
    var tap_floored: CGRect {
        
        return CGRect(origin: self.origin.tap_ceiled, size: self.size.tap_floored)
    }
    
    /// Returns center point of CGRect.
    var tap_center: CGPoint {
        
        return CGPoint(x: self.midX, y: self.midY)
    }
    
    /// Returns top center point.
    var tap_topCenter: CGPoint {
        
        return CGPoint(x: self.midX, y: self.minY)
    }
    
    /// Returns bottom center point.
    var tap_bottomCenter: CGPoint {
        
        return CGPoint(x: self.midX, y: self.maxY)
    }
    
    /// Returns left center point.
    var tap_leftCenter: CGPoint {
        
        return CGPoint(x: self.minX, y: self.midY)
    }
    
    /// Returns right center point.
    var tap_rightCenter: CGPoint {
        
        return CGPoint(x: self.maxX, y: self.midY)
    }
    
    /// Returns top left point.
    var tap_topLeftCorner: CGPoint {
        
        return CGPoint(x: self.minX, y: self.minY)
    }
    
    /// Returns top right point.
    var tap_topRightCorner: CGPoint {
        
        return CGPoint(x: self.maxX, y: self.minY)
    }
    
    /// Returns bottom left point.
    var tap_bottomLeftCorner: CGPoint {
        
        return CGPoint(x: self.minX, y: self.maxY)
    }
    
    /// Returns bottom right point.
    var tap_bottomRightCorner: CGPoint {
        
        return CGPoint(x: self.maxX, y: self.maxY)
    }
    
    /// Returns a rect replacing all NaNs with 0.0.
    var tap_withoutNans: CGRect {
        
        return CGRect(x: self.origin.x.isNaN ? 0.0 : self.origin.x,
                      y: self.origin.y.isNaN ? 0.0 : self.origin.y,
                      width: self.width.isNaN ? 0.0 : self.width,
                      height: self.height.isNaN ? 0.0 : self.height)
    }
    
    // MARK: Methods
    
    /// Returns receiver clipped with a given rect.
    ///
    /// - Parameter rect: Clipping rect.
    /// - Returns: Receiver clipped with a given rect.
    func tap_clip(with rect: CGRect) -> CGRect {
        
        guard self.intersects(rect) else { return CGRect.zero }
        
        return self.intersection(rect)
    }
    
    /// Returns resized copy of the receiver within the same origin.
    ///
    /// - Parameter delta: Delta size.
    /// - Returns: CGRect(origin, size + delta)
    func tap_resized(by delta: CGSize) -> CGRect {
        
        return CGRect(origin: self.origin, size: self.size + delta)
    }
    
    /// Returns scaled copy of the receiver.
    ///
    /// - Parameter scaleFactor: Scale factor.
    /// - Returns: CGRect(origin * scaleFactor, size * scaleFactor)
    func tap_scaled(by scaleFactor: CGFloat) -> CGRect {
        
        return CGRect(origin: self.origin * scaleFactor, size: self.size * scaleFactor)
    }
    
    /// Returns moved copy of the receiver.
    ///
    /// - Parameter offset: Offset.
    /// - Returns: CGRect(origin + offset, size)
    func tap_moved(by offset: CGPoint) -> CGRect {
        
        return CGRect(origin: self.origin + offset, size: self.size)
    }
}
