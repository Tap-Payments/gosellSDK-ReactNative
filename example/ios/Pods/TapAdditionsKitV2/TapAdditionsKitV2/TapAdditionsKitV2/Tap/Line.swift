//
//  Line.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGGeometry.CGPoint

/// Line structure.
public struct Line {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Point A.
    public var a: CGPoint
    
    /// Point B.
    public var b: CGPoint
    
    /// Returns middle of the line.
    public var center: CGPoint {
        
        return 0.5 * ( self.a + self.b )
    }
    
    /// Returns control point for the edges of the line. Often used in UIBezierPath.
    public var controlPoint: CGPoint {
        
        var cPoint = self.center
        
        let diffY = abs(self.b.y - cPoint.y)
        if self.a.y < self.b.y {
            
            cPoint.y += diffY
        }
        else if self.a.y > self.b.y {
            
            cPoint.y -= diffY
        }
        
        return cPoint
    }
    
    // MARK: Methods
    
    /// Initializes a line with coordinates of start and end point.
    ///
    /// - Parameters:
    ///   - pointA: Start point.
    ///   - pointB: End point.
    public init(_ pointA: CGPoint, _ pointB: CGPoint) {
        
        self.a = pointA
        self.b = pointB
    }
}
