//
//  MemoryLayout+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Dummy struct to import SwiftStandartLibrary/MemoryLayout module.
public struct MemoryLayoutAdditions {
    
    /// Memory size of a type.
    ///
    /// - Parameter _: Type.
    /// - Returns: memory size of a type.
    public static func tap_sizeof<ObjectType>(_ : ObjectType.Type) -> Int {
        
        return MemoryLayout<ObjectType>.size
    }
    
    /// Memory size of an object.
    ///
    /// - Parameter _: Object.
    /// - Returns: Memory size of an object.
    public static func tap_sizeof<Object> (_ object: Object) -> Int {
        
        return MemoryLayout<Object>.size(ofValue: object)
    }
    
    /// Memory size of an array.
    ///
    /// - Parameter value: Array.
    /// - Returns: Memory size of an array.
    public static func tap_sizeof<ArrayElements>(_ value: [ArrayElements]) -> Int {
        
        return MemoryLayout<ArrayElements>.size * value.count
    }
    
    /*@available (*, unavailable) private init() {
        
        fatalError("\(self) cannot be initialized.")
    }*/
}
