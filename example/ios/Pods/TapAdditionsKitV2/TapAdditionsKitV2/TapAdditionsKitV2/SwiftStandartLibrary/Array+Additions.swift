//
//  Array+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Useful extension to array.
public extension Array {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// + operator for same typed arrays.
    ///
    /// - Parameters:
    ///   - lhs: Left operand.
    ///   - rhs: Right operand.
    /// - Returns: lhs + rhs
    static func + (lhs: [Element], rhs: [Element]) -> [Element] {
        
        var result: [Element] = []
        result.append(contentsOf: lhs)
        result.append(contentsOf: rhs)
        
        return result
    }
    
    /// += operator for same typed arrays.
    ///
    /// - Parameters:
    ///   - lhs: Left operand.
    ///   - rhs: Right operand.
    /// - Returns: lhs = lhs + rhs
    @discardableResult static func += (lhs: inout [Element], rhs: [Element]) -> [Element] {
        
        lhs.append(contentsOf: rhs)
        
        return lhs
    }
    
    /// + operator for an array and element.
    ///
    /// - Parameters:
    ///   - lhs: Left operand.
    ///   - rhs: Right operand.
    /// - Returns: lhs + [rhs]
    static func + (lhs: [Element], rhs: Element) -> [Element] {
        
        return lhs + [rhs]
    }
    
    /// + operator for array and array element.
    ///
    /// - Parameters:
    ///   - lhs: Left operand.
    ///   - rhs: Right operand.
    /// - Returns: lhs = lhs + [rhs]
    @discardableResult static func += (lhs: inout [Element], rhs: Element) -> [Element] {
        
        lhs.append(rhs)
        return lhs
    }
    
    /// + operator for array and array element.
    ///
    /// - Parameters:
    ///   - lhs: Left operand.
    ///   - rhs: Right operand.
    /// - Returns: [lhs] + rhs
    static func + (lhs: Element, rhs: [Element]) -> [Element] {
        
        var result: [Element] = []
        result.append(lhs)
        result.append(contentsOf: rhs)
        
        return result
    }
}

// MARK: Element: Equatable
public extension Array where Element: Equatable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns copy of the receiver by removing duplicates.
    var tap_removingDuplicates: [Element] {
        
        var result: [Element] = []
        
        for object in self {
            
            if !result.contains(object) {
                
                result.append(object)
            }
        }
		
        return result
    }
    
    // MARK: Methods
    
    /// - operator for two arrays.
    ///
    /// - Parameters:
    ///   - lhs: Left operand.
    ///   - rhs: Right operand.
    /// - Returns: lhs - rhs
    static func - (lhs: [Element], rhs: [Element]) -> [Element] {
        
        var result: [Element] = []
        result.append(contentsOf: lhs)
        
        for object in rhs {
            
            result -= object
        }
        
        return result
    }
    
    /// -= operator for two arrays.
    ///
    /// - Parameters:
    ///   - lhs: Left operand.
    ///   - rhs: Right operand.
    /// - Returns: lhs = lhs - rhs
    @discardableResult static func -= (lhs: inout [Element], rhs: [Element]) -> [Element] {
        
        for object in rhs {
            
            lhs -= object
        }
        
        return lhs
    }
    
    /// - operator for array and array element.
    ///
    /// - Parameters:
    ///   - lhs: Left operand.
    ///   - rhs: Right operand.
    /// - Returns: lhs - [rhs]
    static func - (lhs: [Element], rhs: Element) -> [Element] {
        
        return lhs - [rhs]
    }
    
    /// -= operator for array and array element.
    ///
    /// - Parameters:
    ///   - lhs: Left operand.
    ///   - rhs: Right operand.
    /// - Returns: lhs = lhs - [rhs]
    @discardableResult static func -= (lhs: inout [Element], rhs: Element) -> [Element] {
        
        if let index = lhs.firstIndex(of: rhs) {
            
            lhs.remove(at: index)
        }
        
        return lhs
    }
    
    /// Removes all the duplicates from the receiver.
    mutating func tap_removeDuplicates() {
        
        self = self.tap_removingDuplicates
    }
    
    /// Returns a new array that is a copy of the receiving array with a given array of objects left.
    ///
    /// - Parameter array: Array of objects that needs to be left
    /// - Returns: Array of left objects.
    func tap_byLeavingObjects(from array: [Element]) -> [Element] {
        
        guard array.count > 0 && self.count > 0 else { return [] }
        
        var result: [Element] = [Element](self)
        
        for index in (0..<self.count).reversed() {
            
            if !array.contains(result[index]) {
                
                result.remove(at: index)
            }
        }
        
        return result
    }
}

public extension Array where Element: Numeric {
    
    /// Interpolates two arrays.
    ///
    /// - Parameters:
    ///   - start: Array of left bounds.
    ///   - finish: Array of right bounds.
    ///   - progress: Progress in range [0, 1].
    /// - Returns: Interpolated array.
    static func tap_interpolate(start: [Element], finish: [Element], progress: Element) -> [Element] {
        
        let arrayLength = start.count
        guard arrayLength > 0 else { return [] }
        
        guard arrayLength == finish.count else {
            
            fatalError("Arrays should have equal nonnull lengths.")
        }
        
        return zip(start, finish).map { Element.tap_interpolate(start: $0.0, finish: $0.1, progress: progress) }
    }
}

/// Interpolates two arrays.
///
/// - Parameters:
///   - start: Array of left bounds.
///   - finish: Array of right bounds.
///   - progress: Progress in range [0, 1].
/// - Returns: Interpolated array.
public func tap_interpolate<Type>(start: [Type], finish: [Type], progress: Type) -> [Type] where Type: Numeric {
    
    return type(of: start).tap_interpolate(start: start, finish: finish, progress: progress)
}
