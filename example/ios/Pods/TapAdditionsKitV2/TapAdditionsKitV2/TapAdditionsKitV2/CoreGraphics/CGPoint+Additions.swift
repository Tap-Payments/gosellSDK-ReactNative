//
//  CGPoint+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import func		Darwin.C.math.atan
import func		Darwin.C.math.ceil
import func		Darwin.C.math.cos
import func		Darwin.C.math.floor
import func		Darwin.C.math.sin
import func		Darwin.C.math.sqrt
import struct	OpenGLES.gltypes.GLfloat

/// Useful extension for CGPoint.
public extension CGPoint {

    // MARK: - Public -
    // MARK: Properties

    /// Returns vec2 representation of CGPoint.
    var tap_asVec2: [GLfloat] {

        return [GLfloat(self.x), GLfloat(self.y)]
    }

    /// Returns point as CGSize.
    var tap_asCGSize: CGSize {
        
        return CGSize(width: self.x, height: self.y)
    }
    
    /// Returns the receiver as a tuple.
    var tap_asTuple: (CGFloat, CGFloat) {
        
        return (self.x, self.y)
    }
    
    /// Returns distance to point (0, 0).
    var tap_distanceToOrigin: CGFloat {
        
        return sqrt(self * self)
    }
    
    /// Returns ceiled receiver.
    var tap_ceiled: CGPoint {
        
        return CGPoint(x: ceil(self.x), y: ceil(self.y))
    }
    
    /// Returns floored receiver.
    var tap_floored: CGPoint {
        
        return CGPoint(x: floor(self.x), y: floor(self.y))
    }
    
    /// Returns the angle between vector (.zero, self) and OX.
    var tap_angle: CGFloat {
        
        switch self.tap_asTuple {
            
        case (let x, 0.0):
            
            return x < 0.0 ? CGFloat.pi : 0.0
            
        case (0.0, let y):
            
            return CGFloat.pi * ( 0.5 + (y > 0.0 ? 0.0 : 1.0) )
            
        case ( CGFloat.leastNonzeroMagnitude..., CGFloat.leastNonzeroMagnitude...):
            
            return CGFloat(atan(Double(self.y / self.x)))
            
        case (..<0.0, CGFloat.leastNonzeroMagnitude...):
            
            return CGFloat.pi - CGFloat(atan(Double(-self.y / self.x)))
            
        case (..<0.0, ..<0.0):
            
            return CGFloat.pi + CGFloat(atan(Double(self.y / self.x)))
            
        case (CGFloat.leastNonzeroMagnitude..., ..<0.0):
            
            return 2.0 * CGFloat.pi - CGFloat(atan(Double(-self.y / self.x)))
            
        default:
            
            fatalError("The receiver is not a valid point")
        }
    }
    
    // MARK: Methods
    
    /// Returns the point rotated on a given angle around the start of coordinate system.
    ///
    /// - Parameter angle: Angle in radians.
    /// - Returns: Point rotated on a given angle around the start of coordinate system.
    func tap_rotated(on angle: CGFloat) -> CGPoint {
        
        let dAngle = Double(angle)
        let s = CGFloat(sin(dAngle))
        let c = CGFloat(cos(dAngle))
        
        return CGPoint(x: self.x * c - self.y * s, y: self.y * c + self.x * s)
    }
    
    /// Rotates the receiver on a given angle around the start of coordinate system.
    ///
    /// - Parameter angle: Angle in radians
    /// - Returns: Rotated receiver.
    @discardableResult mutating func tap_rotate(on angle: CGFloat) -> CGPoint {
        
        self = self.tap_rotated(on: angle)
        return self
    }
    
    /// Adds point to the receiver.
    ///
    /// - Parameter point: Point to add coordinates.
    /// - Returns: New point with added coordinates.
    func tap_add(_ point: CGPoint) -> CGPoint {
        
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }
    
    /// Scales receiver by a given scale factor.
    ///
    /// - Parameter scaleFactor: Scale factor.
    /// - Returns: New point with scaled coordinates.
    func tap_scale(_ scaleFactor: CGFloat) -> CGPoint {
        
        return CGPoint(x: self.x * scaleFactor, y: self.y * scaleFactor)
    }
    
    /// Subtracts point from the receiver.
    ///
    /// - Parameter point: Point to subtract coordinates.
    /// - Returns: New point with subtracted coordinates.
    func tap_subtract(_ point: CGPoint) -> CGPoint {
        
        return self.tap_add(point.tap_scale(-1.0))
    }
    
    /// Add operator for points.
    ///
    /// - Parameters:
    ///   - left:  Left point.
    ///   - right: Right point.
    /// - Returns: left + right.
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        
        return left.tap_add(right)
    }
    
    /// Subtract operator for points.
    ///
    /// - Parameters:
    ///   - left: Left point.
    ///   - right: Right point.
    /// - Returns: left - right.
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        
        return left.tap_subtract(right)
    }
    
    /// Multiplication on scalar value.
    ///
    /// - Parameters:
    ///   - left: Point.
    ///   - right: Scalar.
    /// - Returns: left * right.
    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        
        return left.tap_scale(right)
    }
    
    /// Multiplication on scalar value.
    ///
    /// - Parameters:
    ///   - left: Scalar.
    ///   - right: Point.
    /// - Returns: left * right.
    static func * (left: CGFloat, right: CGPoint) -> CGPoint {
        
        return right.tap_scale(left)
    }
    
    /// Scalar multiplication of points.
    ///
    /// - Parameters:
    ///   - left: Left point.
    ///   - right: Right point.
    /// - Returns: left * right.
    static func * (left: CGPoint, right: CGPoint) -> CGFloat {
        
        return left.x * right.x + left.y * right.y
    }
}
