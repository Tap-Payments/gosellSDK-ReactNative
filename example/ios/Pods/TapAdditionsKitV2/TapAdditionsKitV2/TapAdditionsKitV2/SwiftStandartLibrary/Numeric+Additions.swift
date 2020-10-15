//
//  Numeric+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

public extension Numeric {
    
    /// Interpolates value between start and finish.
    ///
    /// - Parameters:
    ///   - start: Left bound.
    ///   - finish: Right bound.
    ///   - progress: Progress in range [0, 1]
    /// - Returns: Interpolated value.
    static func tap_interpolate<Type>(start: Type, finish: Type, progress: Type) -> Type where Type: Numeric {
        
        return start + (finish - start) * progress
    }
}
