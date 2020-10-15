//
//  Sequence+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/**
 *  Addable protocol.
 */
public protocol Addable {
    
    init()
    static func + (lhs: Self, rhs: Self) -> Self
}

extension Int: Addable {}
extension Decimal: Addable {}

public extension Sequence where Element: Numeric {
    
    static func * (lhs: Element, rhs: Self) -> [Element] {

        return rhs.map { $0 * lhs }
    }
    
    static func * (lhs: Self, rhs: Element) -> [Element] {
        
        return lhs.map { $0 * rhs }
    }
}

/// Useful Sequence extension.
public extension Sequence where Iterator.Element: Addable {
    
    /// Returns sum of elements.
    var tap_sum: Iterator.Element {
        
        return self.reduce(Iterator.Element()) { $0 + $1 }
    }
}

/// Another useful Sequence extension.
public extension Sequence where Iterator.Element: BinaryInteger {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns GCD of the sequence.
    var tap_gcd: Iterator.Element {
        
        let elementsCount = self.underestimatedCount
        
        guard elementsCount > 1 else { fatalError("To call GCD there should be at least 2 elements in a sequence") }
        
        var result = self[0]
        
        for index in 1..<elementsCount {
            
            result = type(of: self).tap_pairGCD(a: self[UInt(index)], b: result)
        }
        
        return result
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private subscript(index: UInt) -> Iterator.Element {
        
        if let selfArray = self as? [Iterator.Element] {
            
            return selfArray[Int(index)]
        }
        else {
            
            return Array(self)[index]
        }
    }
    
    // MARK: Methods
    
    private static func tap_pairGCD(a: Iterator.Element, b: Iterator.Element) -> Iterator.Element {
        
        if a < b {
            
            return self.tap_pairGCD(a: b, b: a)
        }
        
        var tempA = a
        var tempB = b
        
        while true {
            
            let r = tempA % tempB
            
            if r == ( r - r ) {
                
                return tempB
            }
            
            tempA = tempB
            tempB = r
        }
    }
}
