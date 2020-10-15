//
//  CAKeyframeAnimation+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class		Foundation.NSValue.NSNumber
import class		Foundation.NSValue.NSValue
import class		QuartzCore.CAAnimation.CAKeyframeAnimation
import func			QuartzCore.CATransform3D.CATransform3DMakeScale

#if !swift(>=4.2)
import var			QuartzCore.CAMediaTiming.kCAFillModeForwards
#endif

/// Useful extension to CAKeyframeAnimation
public extension CAKeyframeAnimation {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Popup appearance animation (like UIAlertView).
    static let tap_popupAppearance: CAKeyframeAnimation = {
       
        let animation = CAKeyframeAnimation.tap_transformKeyFrameAnimation
        
        animation.values = CAKeyframeAnimation.tap_popupAppearanceTransforms
        animation.keyTimes = CAKeyframeAnimation.tap_popupAppearanceFrameTimes
		
		#if swift(>=4.2)
        animation.fillMode = .forwards
		#else
		animation.fillMode = kCAFillModeForwards
		#endif
		
        animation.isRemovedOnCompletion = false
        animation.duration = CAKeyframeAnimationConstants.popupAppearanceTimeInterval
        
        return animation
    }()
    
    /// Popup disappearance animation (like UIAlertView).
    static let tap_popupDisappearance: CAKeyframeAnimation = {
       
        let animation = CAKeyframeAnimation.tap_transformKeyFrameAnimation
        
        animation.values = CAKeyframeAnimation.tap_popupDisappearanceTransforms
        animation.keyTimes = CAKeyframeAnimation.tap_popupDisappearanceFrameTimes
		
		#if swift(>=4.2)
		animation.fillMode = .forwards
		#else
		animation.fillMode = kCAFillModeForwards
		#endif
		
        animation.isRemovedOnCompletion = false
        animation.duration = CAKeyframeAnimationConstants.popupDisappearanceTimeInterval
        
        return animation
    }()
    
    // MARK: - Private -
    
    private struct CAKeyframeAnimationConstants {
        
        fileprivate static let popupAppearanceTimeInterval = 0.5
        fileprivate static let popupDisappearanceTimeInterval = 0.18
        
        fileprivate static let transformKeyPath = "transform"
        
        //@available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private static var tap_transformKeyFrameAnimation: CAKeyframeAnimation {
        
        return CAKeyframeAnimation(keyPath: CAKeyframeAnimationConstants.transformKeyPath)
    }
    
    private static let tap_popupAppearanceTransforms: [NSValue] = {
       
        let scale1 = CATransform3DMakeScale(0.5, 0.5, 1.0)
        let scale2 = CATransform3DMakeScale(1.2, 1.2, 1.0)
        let scale3 = CATransform3DMakeScale(0.9, 0.9, 1.0)
        let scale4 = CATransform3DMakeScale(1.0, 1.0, 1.0)
        
        return [NSValue(caTransform3D: scale1), NSValue(caTransform3D: scale2), NSValue(caTransform3D: scale3), NSValue(caTransform3D: scale4)]
    }()
    
    private static let tap_popupDisappearanceTransforms: [NSValue] = {
        
        let scale1 = CATransform3DMakeScale(1.0, 1.0, 1.0)
        let scale2 = CATransform3DMakeScale(0.01, 0.01, 1.0)
        
        return [NSValue(caTransform3D: scale1), NSValue(caTransform3D: scale2)]
    }()
    
    private static let tap_popupAppearanceFrameTimes: [NSNumber] = [0.0, 0.5, 0.9, 1.0]
    
    private static let tap_popupDisappearanceFrameTimes: [NSNumber] = [0.0, 1.0]
}
