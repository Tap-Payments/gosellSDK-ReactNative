//
//  Triangle.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics

// Triangle structure.
public struct Triangle {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Point A.
    public var a: CGPoint
    
    /// Point B.
    public var b: CGPoint
    
    /// Point C.
    public var c: CGPoint
    
    /// Line AB.
    public var ab: Line {
        
        return Line(self.a, self.b)
    }
    
    /// Line AC.
    public var ac: Line {
        
        return Line(self.a, self.c)
    }
    
    /// Line BC.
    public var bc: Line {
        
        return Line(self.b, self.c)
    }
    
    /// Line CB.
    public var cb: Line {
        
        return Line(self.c, self.b)
    }
    
    /// Line CA.
    public var ca: Line {
        
        return Line(self.c, self.a)
    }
    
    /// Line BA.
    public var ba: Line {
        
        return Line(self.b, self.a)
    }
    
    // MARK: Methods
    
    /// Initializes triangle with 3 points.
    ///
    /// - Parameters:
    ///   - pointA: Point A.
    ///   - pointB: Point B.
    ///   - pointC: Point C.
    public init(a pointA: CGPoint, b pointB: CGPoint, c pointC: CGPoint) {
        
        self.a = pointA
        self.b = pointB
        self.c = pointC
    }
    
    /// Determines if the receiver contains given point.
    ///
    /// - Parameter point: Point.
    /// - Returns: Boolean value that determines whether the receiver contains given point.
    public func contains(point: CGPoint) -> Bool {
        
        let position1 = self.positionOf(point, relativeTo: self.ab) < 0.0
        let position2 = self.positionOf(point, relativeTo: self.bc) < 0.0
        let position3 = self.positionOf(point, relativeTo: self.ca) < 0.0
        
        return ( position1 == position2 ) && ( position2 == position3 )
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func positionOf(_ point: CGPoint, relativeTo line: Line) -> CGFloat {
        
        let a = line.a
        let b = line.b
        
        let pmbx = point.x - b.x
        let amby = a.y - b.y
        let pmbxXamby = pmbx * amby
        
        let ambx = a.x - b.x
        let pmby = point.y - b.y
        let ambxXpmby = ambx * pmby
        
        let result = pmbxXamby - ambxXpmby
        return result
    }
}
