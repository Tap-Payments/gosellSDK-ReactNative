//
//  CountableClosedRange+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func		Darwin.C.stdlib.arc4random_uniform

/// Useful addition for CountableClosedRange.
public extension CountableClosedRange where Bound == Int {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns random value of a range.
    var tap_randomValue: Bound {
        
        return Int(arc4random_uniform(UInt32(self.count) + 1)) + self.lowerBound
    }
}
