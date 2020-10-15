//
//  CALayer+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import struct	Foundation.NSDate.TimeInterval
import func		ObjectiveC.runtime.objc_getAssociatedObject
import func		ObjectiveC.runtime.objc_setAssociatedObject
import class	QuartzCore.CALayer
import class	UIKit.UIColor
import struct	UIKit.UIRectEdge

private var tap_borderLayerLeftKey: UInt8 = 0
private var tap_borderLayerRightKey: UInt8 = 0
private var tap_borderLayerTopKey: UInt8 = 0
private var tap_borderLayerBottomKey: UInt8 = 0

/// Useful extension of CALayer class.
public extension CALayer {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns longest animation duration of the layer.
    var tap_longestAnimationDuration: TimeInterval {
        
        var longestDuration = 0.0
        
        if let keys = animationKeys() {
            
            for key in keys {
                
                let animation = self.animation(forKey: key)
                let currentAnimationDuration = animation?.duration ?? 0.0
                if currentAnimationDuration > longestDuration {
                    
                    longestDuration = currentAnimationDuration
                }
            }
        }
        
        if let nonnullSublayers = self.sublayers {
            
            for sublayer in nonnullSublayers {
                
                let duration = sublayer.tap_longestAnimationDuration
                if duration > longestDuration {
                    
                    longestDuration = duration
                }
            }
        }
        
        return longestDuration
    }
    
    // MARK: Methods
    
    /// Removes all animations.
    func tap_removeAnimations(includeSublayers: Bool = true) {
        
        self.removeAllAnimations()
        
        if includeSublayers {
            
            guard let nonnullSublayers = self.sublayers else { return }
            
            for sublayer in nonnullSublayers {
                
                sublayer.tap_removeAnimations()
            }
        }
    }
    
    /**
     Sets border on a given edge.
     
     - parameter edge:  Edge mask to set border for.
     - parameter width: Border width.
     - parameter color: Border color.
     */
    func tap_setBorder(onEdge edge: UIRectEdge, width: CGFloat, color: UIColor?) {
        
        let cgColor = color?.cgColor
        
        if edge.contains(.left) {
            
            self.tap_leftBorderLayer.frame = CGRect(x: 0.0, y: 0.0, width: width, height: bounds.height)
            self.tap_leftBorderLayer.backgroundColor = cgColor
        }
        
        if edge.contains(.right) {
            
            self.tap_rightBorderLayer.frame = CGRect(x: bounds.width - width, y: 0.0, width: width, height: bounds.height)
            self.tap_rightBorderLayer.backgroundColor = cgColor
        }
        
        if edge.contains(.top) {
            
            self.tap_topBorderLayer.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: width)
            self.tap_topBorderLayer.backgroundColor = cgColor
        }
        
        if edge.contains(.bottom) {
            
            self.tap_bottomBorderLayer.frame = CGRect(x: 0.0, y: bounds.height - width, width: bounds.width, height: width)
            self.tap_bottomBorderLayer.backgroundColor = cgColor
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var tap_leftBorderLayer: CALayer {
        
        get {
            
            if let bLayer = objc_getAssociatedObject(self, &tap_borderLayerLeftKey) as? CALayer {
                
                return bLayer
            }
            
            let borderLayer = self.tap_createAndAddBorderLayer()
            self.tap_leftBorderLayer = borderLayer
            
            return borderLayer
        }
        set {
            
            objc_setAssociatedObject(self, &tap_borderLayerLeftKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var tap_rightBorderLayer: CALayer {
        
        get {
            
            if let bLayer = objc_getAssociatedObject(self, &tap_borderLayerRightKey) as? CALayer {
                
                return bLayer
            }
            
            let borderLayer = self.tap_createAndAddBorderLayer()
            self.tap_rightBorderLayer = borderLayer
            
            return borderLayer
        }
        set {
            
            objc_setAssociatedObject(self, &tap_borderLayerRightKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var tap_topBorderLayer: CALayer {
        
        get {
            
            if let bLayer = objc_getAssociatedObject(self, &tap_borderLayerTopKey) as? CALayer {
                
                return bLayer
            }
            
            let borderLayer = self.tap_createAndAddBorderLayer()
            self.tap_topBorderLayer = borderLayer
            
            return borderLayer
        }
        set {
            
            objc_setAssociatedObject(self, &tap_borderLayerTopKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var tap_bottomBorderLayer: CALayer {
        
        get {
            
            if let bLayer = objc_getAssociatedObject(self, &tap_borderLayerBottomKey) as? CALayer {
                
                return bLayer
            }
            
            let borderLayer = self.tap_createAndAddBorderLayer()
            self.tap_bottomBorderLayer = borderLayer
            
            return borderLayer
        }
        set {
            
            objc_setAssociatedObject(self, &tap_borderLayerBottomKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: Methods
    
    private func tap_createAndAddBorderLayer() -> CALayer {
        
        let borderLayer = CALayer()
        borderLayer.bounds = bounds
        borderLayer.backgroundColor = UIColor.clear.cgColor
        
        self.addSublayer(borderLayer)
        
        return borderLayer
    }
}
