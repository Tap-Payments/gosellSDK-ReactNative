//
//  UIResponder+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	QuartzCore.CATransaction.CATransaction
import class	UIKit.UIApplication.UIApplication
import class	UIKit.UIResponder.UIResponder
import class	UIKit.UIView.UIView

/// Useful additions to UIResponder.
public extension UIResponder {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns current first responder.
    static var tap_current: UIResponder? {
        
        self.tap_currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(tap_findFirstResponder), to: nil, from: nil, for: nil)
        
        return self.tap_currentFirstResponder
    }
    
    // MARK: Methods
    
    func tap_resignFirstResponder(_ completion: @escaping TypeAlias.ArgumentlessClosure) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        self.resignFirstResponder()
        
        CATransaction.commit()
    }
    
    static func tap_resign(in view: UIView? = nil, _ completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        let localCompletion: TypeAlias.ArgumentlessClosure = {
            
            completion?()
        }
        
        if let nonnullView = view {
            
            if let responder = nonnullView.tap_firstResponder {
                
                responder.tap_resignFirstResponder(localCompletion)
            }
            else {
                
                localCompletion()
            }
        }
        else if let responder = self.tap_current {
            
            responder.tap_resignFirstResponder(localCompletion)
        }
        else {
            
            localCompletion()
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private static weak var tap_currentFirstResponder: UIResponder?
    
    // MARK: Methods
    
    @objc private func tap_findFirstResponder() {
        
        if let view = self as? UIView {
            
            UIResponder.tap_currentFirstResponder = view.tap_firstResponder
        }
        else {
            
            UIResponder.tap_currentFirstResponder = self
        }
    }
}
