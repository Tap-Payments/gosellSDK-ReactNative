//
//  AnimationOptions+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIView.UIView

public extension UIView.AnimationOptions {
    
    // MARK: - Public -
    // MARK: Methods
    
    init(tap_curve: UIView.AnimationCurve) {
        
        switch tap_curve {
            
        case .easeIn:       self = .curveEaseIn
        case .easeOut:      self = .curveEaseOut
        case .easeInOut:    self = .curveEaseInOut
        case .linear:       self = .curveLinear
            
		@unknown default:
			
			print("Attempted to instantiate UIView.AnimationOptions with UIView.AnimationCurve value \(tap_curve) which is not yet supported. Using linear curve instead.")
			self = .curveLinear
		}
    }
}
