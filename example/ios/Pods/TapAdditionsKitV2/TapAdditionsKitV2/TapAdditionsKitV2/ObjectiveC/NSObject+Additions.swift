//
//  NSObject+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	Foundation.NSDate.TimeInterval
import class	ObjectiveC.NSObject.NSObject
import struct	ObjectiveC.Selector

/// Some extensions to NSObject.
public extension NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /*!
     Returns class name as string.
     */
    static var tap_className: String {
        
        return "\(self)"
    }
    
    /// Returns class name as string.
    var tap_className: String {
        
        return type(of: self).tap_className
    }
    
    // MARK: Methods
    
    /*!
     Returns the receiver as Self.
     
     - returns: Receiver as Self
     */
    func tap_asSelf<T>() -> T {
        
        guard let result = self as? T else {
            
            fatalError("Receiver is not convertible to Self.")
        }
        
        return result
    }
    
    /*!
     Performs given selector on main thread after delay.
     
     - parameter selector:      Selector to be called by receiver.
     - parameter object:        Object.
     - parameter delay:         Delay in seconds.
     - parameter waitUntilDone: Defines if main thread will wait for execution finishes.
     */
    func tap_performSelectorOnMainThread(_ aSelector: Selector, withObject object: AnyObject?, afterDelay delay: TimeInterval, waitUntilDone: Bool) {
        
        let dispatchDelay = DispatchTime.now() + delay
        
        DispatchQueue.main.asyncAfter(deadline: dispatchDelay) { [weak self] in
            
            self?.performSelector(onMainThread: aSelector, with: object, waitUntilDone: waitUntilDone)
        }
    }
}
