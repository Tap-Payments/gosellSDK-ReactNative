//
//  CGSize+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import func		Darwin.ceil
import func		Darwin.floor
import struct	OpenGLES.gltypes.GLfloat

/// Useful addition to CGSize.
public extension CGSize {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Minimal image size in pixels to upload to Instagram.
	static let tap_minimalInstagramImageSizeInPixels: CGSize = CGSize(tap_dimension: 612.0)
    
    /// Returns area.
    var tap_area: CGFloat {
        
        return self.width * self.height
    }
    
    /// Returns CGSize as CGPoint
    var tap_asCGPoint: CGPoint {
        
        return CGPoint(x: self.width, y: self.height)
    }
    
    /// Returns vec2 representation of CGSize.
    var tap_asVec2: [GLfloat] {
        
        return [GLfloat(self.width), GLfloat(self.height)]
    }
    
    /// Returns ceiled receiver.
    var tap_ceiled: CGSize {
        
        return CGSize(width: ceil(self.width), height: ceil(self.height))
    }
    
    /// Returns floored receiver.
    var tap_floored: CGSize {
        
        return CGSize(width: floor(self.width), height: floor(self.height))
    }
    
    /// Returns maximal allowed corner radius.
    var tap_maximalCornerRadus: CGFloat {
        
        return 0.5 * min(self.width, self.height)
    }
    
    /// Defines if size has square form.
    var tap_isSquare: Bool {
        
        return self.width == self.height
    }
    
    // MARK: Methods
    
    /// Initializes square size with the given `tap_dimension`.
    ///
    /// - Parameter tap_dimension: Dimension.
    init(tap_dimension: CGFloat) {
        
        self.init(width: tap_dimension, height: tap_dimension)
    }
    
    /// Defines if the receiver fully fits into `size`.
    ///
    /// - Parameter size: Size to check.
    /// - Returns: `true` if fits, `false` otherwise.
    func tap_fits(into size: CGSize) -> Bool {
        
        return self.width <= size.width && self.height <= size.height
    }
    
    /// + operator.
    ///
    /// - Parameters:
    ///   - left: Left operand.
    ///   - right: Right operand.
    /// - Returns: left + right.
    static func + (left: CGSize, right: CGSize) -> CGSize {
        
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    
    /// - operator.
    ///
    /// - Parameters:
    ///   - left: Left operand.
    ///   - right: Right operand.
    /// - Returns: left - right.
    static func - (left: CGSize, right: CGSize) -> CGSize {
        
        return CGSize(width: left.width - right.width, height: left.height - right.height)
    }
    
    /// * operator between CGSize and CGFloat
    ///
    /// - Parameters:
    ///   - left: CGSize
    ///   - right: CGFloat
    /// - Returns: left * right
    static func * (left: CGSize, right: CGFloat) -> CGSize {
        
        return CGSize(width: left.width * right, height: left.height * right)
    }
    
    /// * operator between CGSize and CGFloat
    ///
    /// - Parameters:
    ///   - left: CGFloat
    ///   - right: CGSize
    /// - Returns: left * right
    static func * (left: CGFloat, right: CGSize) -> CGSize {
        
        return CGSize(width: right.width * left, height: right.height * left)
    }
    
    /// Fits the receiver to the given size, optionally saving proportions.
    ///
    /// - Parameters:
    ///   - size: Size to fit to.
    ///   - saveProportions: Boolean value that determines whether the receiver's proportions should be saved. Default is true.
    /// - Returns: Fitted size.
    func tap_fit(to size: CGSize, saveProportions: Bool = true) -> CGSize {
        
        if saveProportions {
            
            let scale = min(size.width / self.width, size.height / self.height, 1.0)
            return scale * self
        }
        else {
            
            return CGSize(width: min(self.width, size.width), height: min(self.height, size.height))
        }
    }
    
    /// Interpolates CGSize value between start and finish.
    ///
    /// - Parameters:
    ///   - start: Left bound.
    ///   - finish: Right bound.
    ///   - progress: Progress in range [0, 1]
    /// - Returns: Interpolated value.
    static func tap_interpolate(start: CGSize, finish: CGSize, progress: CGFloat) -> CGSize {
        
        return CGSize(width: CGFloat.tap_interpolate(start: start.width, finish: finish.width, progress: progress),
                      height: CGFloat.tap_interpolate(start: start.height, finish: finish.height, progress: progress))
    }
}
