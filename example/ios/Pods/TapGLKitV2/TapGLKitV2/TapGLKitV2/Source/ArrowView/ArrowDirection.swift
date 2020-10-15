//
//  ArrowDirection.swift
//  TapGLKit/ArrowView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGGeometry.CGPoint
import struct CoreGraphics.CGGeometry.CGRect
import struct CoreGraphics.CGGeometry.CGSize
import struct TapAdditionsKitV2.Triangle
import class UIKit.UIScreen.UIScreen

/// Arrow direction.
///
/// - bottomToTop: From bottom to top.
/// - topToBottom: From top to bottom.
/// - leftToRight: From left to right.
/// - rightToLeft: From right to left.
/// - topLeftToBottomRightStraight: From top left corner to bottom right corner using center as a control point.
/// - topLeftToBottomRight: From top left corner to bottom right corner using bottom left corner as a control point.
/// - topLeftToRightBottom: From top left corner to bottom right corner using top right corner as a control point.
/// - topRightToBottomLeftStraight: From top right corner to bottom left corner using center as a control point.
/// - topRightToBottomLeft: From top right corner to bottom left corner using bottom right corner as a control point.
/// - topRightToLeftBottom: From top right corner to bottom left corner using top left corner as a control point.
/// - bottomLeftToTopRightStraight: From bottom left corner to top right corner using center as a control point.
/// - bottomLeftToTopRight: From bottom left corner to top right corner using top left corner as a control point.
/// - bottomLeftToRightTop: From bottom left corner to top right corner using bottom right corner as a control point.
/// - bottomRightToTopLeftStraight: From bottom right corner to top left corner using center as a control point.
/// - bottomRightToTopLeft: From bottom right corner to top left corner using top right corner as a control point.
/// - bottomRightToLeftTop: From bottom right corner to top left corner using bottom left corner as a control point.
public enum ArrowDirection: Int {
    
    case bottomToTop = 1
    case topToBottom
    case leftToRight
    case rightToLeft
    
    case topLeftToBottomRightStraight
    case topLeftToBottomRight
    case topLeftToRightBottom
    
    case topRightToBottomLeftStraight
    case topRightToBottomLeft
    case topRightToLeftBottom
    
    case bottomLeftToTopRightStraight
    case bottomLeftToTopRight
    case bottomLeftToRightTop
    
    case bottomRightToTopLeftStraight
    case bottomRightToTopLeft
    case bottomRightToLeftTop
    
    //MARK: - Public -
    //MARK: Methods
    
    /// Returns suggested arrow direction based on position of the target rect on the screen.
    ///
    /// - Parameter targetRect: Target rect.
    /// - Returns: Suggested arrow direction.
    public static func suggested(for targetRect: CGRect) -> ArrowDirection {
        
        let rectCenter = targetRect.tap_center
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let oneThird  = CGSize(width: width / 3.0, height: height / 3.0)
        let twoThirds = CGSize(width: 2.0 * oneThird.width, height: 2.0 * oneThird.height)
        let halfHeight = height * 0.5
        
        if CGRect(x: oneThird.width, y: 0.0, width: oneThird.width, height: halfHeight).contains(rectCenter) {
            
            return .bottomToTop
        }
        else if CGRect(x: 0.0, y: oneThird.height, width: oneThird.width, height: oneThird.height).contains(rectCenter) {
            
            return .rightToLeft
        }
        else if CGRect(x: oneThird.width, y: halfHeight, width: oneThird.width, height: halfHeight).contains(rectCenter) {
            
            return .topToBottom
        }
        else if CGRect(x: twoThirds.width, y: oneThird.height, width: oneThird.width, height: oneThird.height).contains(rectCenter) {
            
            return .leftToRight
        }
        else if Triangle(a: oneThird.tap_asCGPoint, b: CGPoint(x: 0.0, y: oneThird.height), c: .zero).contains(point: rectCenter) {
            
            return .bottomRightToLeftTop
        }
        else if Triangle(a: CGPoint(x: twoThirds.width, y: oneThird.height), b: CGPoint(x: width, y: oneThird.height), c: CGPoint(x: width, y: 0.0)).contains(point: rectCenter) {
            
            return .bottomLeftToRightTop
        }
        else if Triangle(a: oneThird.tap_asCGPoint, b: CGPoint(x: oneThird.width, y: 0.0), c: .zero).contains(point: rectCenter) {
            
            return .bottomRightToTopLeft
        }
        else if Triangle(a: CGPoint(x: oneThird.width, y: twoThirds.height), b: CGPoint(x: oneThird.width, y: height), c: CGPoint(x: 0.0, y: height)).contains(point: rectCenter) {
            
            return .topRightToBottomLeft
        }
        else if Triangle(a: CGPoint(x: oneThird.width, y: twoThirds.height), b: CGPoint(x: 0.0, y: twoThirds.height), c: CGPoint(x: 0.0, y: height)).contains(point: rectCenter) {
            
            return .topRightToLeftBottom
        }
        else if Triangle(a: twoThirds.tap_asCGPoint, b: CGPoint(x: width, y: twoThirds.height), c: CGPoint(x: width, y: height)).contains(point: rectCenter) {
            
            return .topLeftToRightBottom
        }
        else if Triangle(a: CGPoint(x: twoThirds.width, y: oneThird.height), b: CGPoint(x: twoThirds.width, y: 0.0), c: CGPoint(x: width, y: 0.0)).contains(point: rectCenter) {
            
            return .bottomLeftToTopRight
        }
        else if Triangle(a: twoThirds.tap_asCGPoint, b: CGPoint(x: twoThirds.width, y: height), c: CGPoint(x: width, y: height)).contains(point: rectCenter) {
            
            return .topLeftToBottomRight
        }
        
        return .topToBottom
    }
    
    //MARK: - Internal -
    //MARK: Properties
    
    internal var isStraight: Bool {
        
        switch self {
            
        case .bottomToTop, .topToBottom, .leftToRight, .rightToLeft, .topLeftToBottomRightStraight, .topRightToBottomLeftStraight, .bottomLeftToTopRightStraight, .bottomRightToTopLeftStraight:
            
            return true
            
        default:
            
            return false
        }
    }
    
    internal var startPoint: CGPoint {
        
        switch self {
            
        case .bottomToTop:
            
            return CGPoint(x: 0.5, y: 1.0)
            
        case .topToBottom:
            
            return CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            
            return CGPoint(x: 0.0, y: 0.5)
            
        case .rightToLeft:
            
            return CGPoint(x: 1.0, y: 0.5)
            
        case .topLeftToBottomRightStraight, .topLeftToBottomRight, .topLeftToRightBottom:
            
            return CGPoint(x: 0.0, y: 0.0)
            
        case .topRightToBottomLeftStraight, .topRightToBottomLeft, .topRightToLeftBottom:
            
            return CGPoint(x: 1.0, y: 0.0)
            
        case .bottomLeftToTopRightStraight, .bottomLeftToRightTop, .bottomLeftToTopRight:
            
            return CGPoint(x: 0.0, y: 1.0)
            
        case .bottomRightToTopLeftStraight, .bottomRightToLeftTop, .bottomRightToTopLeft:
            
            return CGPoint(x: 1.0, y: 1.0)
        }
    }
    
    internal var maximalAllowedDrawingDistance: CGPoint {
        
        switch self {
            
        case .leftToRight, .rightToLeft:
            
            return CGPoint(x: 1.0, y: 0.0)
            
        case .topToBottom, .bottomToTop:
            
            return CGPoint(x: 0.0, y: 1.0)
            
        default:
            
            return CGPoint(x: 1.0, y: 1.0)
        }
    }
    
    internal var endDirection: CGPoint {
        
        switch self {
            
        case .bottomToTop, .bottomLeftToRightTop, .bottomRightToLeftTop:
            
            return CGPoint(x: 0.0, y: -1.0)
            
        case .rightToLeft, .topRightToBottomLeft, .bottomRightToTopLeft:
            
            return CGPoint(x: -1.0, y: 0.0)
            
        case .topToBottom, .topLeftToRightBottom, .topRightToLeftBottom:
            
            return CGPoint(x: 0.0, y: 1.0)
            
        case .leftToRight, .topLeftToBottomRight, .bottomLeftToTopRight:
            
            return CGPoint(x: 1.0, y: 0.0)
            
        case .topLeftToBottomRightStraight:
            
            return CGPoint(x: 1.0, y: 1.0)
            
        case .topRightToBottomLeftStraight:
            
            return CGPoint(x: -1.0, y: 1.0)
            
        case .bottomLeftToTopRightStraight:
            
            return CGPoint(x: 1.0, y: -1.0)
            
        case .bottomRightToTopLeftStraight:
            
            return CGPoint(x: -1.0, y: -1.0)
        }
    }
}
