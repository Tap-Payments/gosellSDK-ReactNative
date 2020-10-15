//
//  Comparable+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum		Foundation.NSObjCRuntime.ComparisonResult

/// Some additions to Comparable protocol.
public extension Comparable {
    
    // MARK: - Public -
    // MARK: Methods.
    
    /**
     Compares receiver to another Comparable object.
     
     - parameter other: Other comparable object.
     
     - returns: NSComparisonResult
     */
    func tap_compare(other: Self) -> ComparisonResult {
        
        if self < other {
            
            return .orderedAscending
        }
        else if self > other {
            
            return .orderedDescending
        }
        else {
            
            return .orderedSame
        }
    }
}

/// Clamps value in range [low, high]
///
/// - Parameters:
///   - value: Value to clamp.
///   - low: Lower bound.
///   - high: Higher bound.
/// - Returns: Clampled value.
public func tap_clamp<T>(value: T, low: T, high: T) -> T where T: Comparable {
    
    return min(max(value, low), high)
}
