//
//  UIBezierPath+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class	UIKit.UIBezierPath

/// Useful extension to UIBezierPath class.
public extension UIBezierPath {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Creates and returns curved UIBezierPath that passes through all the points.
    ///
    /// - Parameter points: Points to pass through.
    /// - Returns: curved UIBezierPath that passes through all the points.
    static func tap_quadCurvedPath(with points: [CGPoint]) -> UIBezierPath {
        
        assert(points.count >= 2, "There should be at least 2 points.")
        
        var point1 = points[0]
        
        let path = UIBezierPath()
        path.move(to: point1)
        
        if points.count == 2 {
            
            path.addLine(to: points[1])
            return path
        }
        
        for index in 1..<points.count {
            
            let point2 = points[index]
            
            let linePoint1Point2 = Line(point1, point2)
            let midPoint = linePoint1Point2.center
            
            let lineMidpointPoint1 = Line(midPoint, point1)
            let controlPoint1 = lineMidpointPoint1.controlPoint
            
            let lineMidpointPoint2 = Line(midPoint, point2)
            let controlPoint2 = lineMidpointPoint2.controlPoint
            
            path.addQuadCurve(to: midPoint, controlPoint: controlPoint1)
            path.addQuadCurve(to: point2, controlPoint: controlPoint2)
            
            point1 = point2
        }
        
        return path
    }
    
    /// Creates and returns curved UIBezierPath that uses Catmull-Rom algorithm to interpolate between given points.
    ///
    /// - Parameters:
    ///   - pointsArray: Points array.
    ///   - closed: Defines if path should be closed.
    ///   - alpha: 0.0 - uniform parametrization, 0.5 - centripetal parametrization, 1.0 - chordal parametrization.
    ///   - includeEdgePoints: Defines if edge points should be included into the curve.
    /// - Returns: curved UIBezierPath that uses Catmull-Rom algorithm to interpolate between given points.
    static func tap_catmullRomInterpolatedPath(with pointsArray: [CGPoint], closed: Bool, alpha: CGFloat, includeEdgePoints: Bool) -> UIBezierPath {
        
        assert(0.0 <= alpha && alpha <= 1.0, "Alpha should be in range [0.0, 1.0]")
        assert(pointsArray.count >= 2, "There should be at least 2 points.")
        
        guard let firstPoint = pointsArray.first, let lastPoint = pointsArray.last else {
         
            fatalError("There should be at least 2 points.")
        }
        
        let points = firstPoint + pointsArray + lastPoint
        
        let path = UIBezierPath()
        let startIndex = closed ? 0 : 1
        let endIndex = closed ? points.count : points.count - 2
        for index in startIndex..<endIndex {
            
            let p0 = points[(index - 1) < 0 ? points.count - 1 : index - 1]
            let p1 = points[index]
            let p2 = points[(index + 1) % points.count]
            let p3 = points[(index + 2) % points.count]
            
            let d1 = (p1 - p0).tap_distanceToOrigin
            let d2 = (p2 - p1).tap_distanceToOrigin
            let d3 = (p3 - p2).tap_distanceToOrigin
            
            var b1: CGPoint
            var b2: CGPoint
            
            if abs(d1) < Constants.epsilon {
                
                b1 = p1
            }
            else {
                
                let powd1alpha = pow(d1, alpha)
                let powd2alpha = pow(d2, alpha)
                
                let powd12alpha = powd1alpha * powd1alpha
                let powd22alpha = powd2alpha * powd2alpha
                
                let powd12alphax2 = 2.0 * powd12alpha
                let powd1alphax3 = 3.0 * powd1alpha
                
                let numeratorpart = powd12alphax2 + powd1alphax3 * powd2alpha + powd22alpha
                let numerator = p2 * powd12alpha - p0 * powd22alpha + p1 * numeratorpart
                let denominator = powd1alphax3 * powd1alpha + powd2alpha
                b1 = numerator * (1.0 / denominator)
            }
            
            if abs(d3) < Constants.epsilon {
                
                b2 = p2
            }
            else {
                
                let powd2alpha = pow(d2, alpha)
                let powd3alpha = pow(d3, alpha)
                
                let powd22alpha = powd2alpha * powd2alpha
                let powd32alpha = powd3alpha * powd3alpha
                
                let powd32alphax2 = 2.0 * powd32alpha
                let powd3alphax3 = 3.0 * powd3alpha
                
                let numeratorpart = powd32alphax2 + powd3alphax3 * powd2alpha + powd22alpha
                let numerator = p1 * powd32alpha - p3 * powd22alpha + p2 * numeratorpart
                let denominator = powd3alphax3 * powd3alpha + powd2alpha
                b2 = numerator * (1.0 / denominator)
            }
            
            if index == startIndex {
                
                path.move(to: p1)
            }
            
            path.addCurve(to: p2, controlPoint1: b1, controlPoint2: b2)
        }
        
        if closed {
            
            path.close()
        }
        
        return path
    }
    
    private struct Constants {
        
        fileprivate static let epsilon: CGFloat = 1.0e-5
        
        //@available(*, unavailable) private init() {}
    }
}
