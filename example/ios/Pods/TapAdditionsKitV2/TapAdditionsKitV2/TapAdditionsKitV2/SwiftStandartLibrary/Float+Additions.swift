//
//  Float+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

// MARK: - Public -
// MARK: Functions

/// Step function.
///
/// - Parameters:
///   - value: Value.
///   - leftBound: Left bound.
///   - rightBound: Right bound.
/// - Returns: Interpolated value between left and right bound (x).
public func tap_step(_ value: Float, _ leftBound: Float, _ rightBound: Float) -> Float {
    
    let val = tap_clamp(value: (value - leftBound) / (rightBound - leftBound), low: 0.0, high: 1.0)
    return val
}

/// Smooth step function.
///
/// - Parameters:
///   - value: Value.
///   - leftBound: Left bound.
///   - rightBound: Right bound.
/// - Returns: Interpolated value between left and right bound (3x^2 - 2x^3).
public func tap_smoothstep(_ value: Float, _ leftBound: Float, _ rightBound: Float) -> Float {
    
    let val = tap_clamp(value: (value - leftBound) / (rightBound - leftBound), low: 0.0, high: 1.0)
    return val * val * ( 3.0 - 2.0 * val )
}

/// Smoother step function.
///
/// - Parameters:
///   - value: Value.
///   - leftBound: Left bound.
///   - rightBound: Right bound.
/// - Returns: Interpolated value between left and right bound (6x^5 - 15x^4 + 10x^3).
public func tap_smootherstep(_ value: Float, _ leftBound: Float, _ rightBound: Float) -> Float {
    
    let val = tap_clamp(value: (value - leftBound) / (rightBound - leftBound), low: 0.0, high: 1.0)
    return val * val * val * (val * (val * 6.0 - 15.0) + 10.0)
}
