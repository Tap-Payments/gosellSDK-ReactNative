//
//  UInt8+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Useful extension to UInt8.
public extension UInt8 {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns char string of the receiver.
    var tap_charString: String {
        
        return String(format: "%c", self)
    }
}
