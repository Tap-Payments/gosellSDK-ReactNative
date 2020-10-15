//
//  Int+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Useful extension to Int.
public extension Int {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Basically converts Int to String.Index type.
    ///
    /// - Parameter string: String.
    /// - Returns: String.Index representation of Int.
    func tap_index(in string: String) -> String.Index {
        
        return string.index(string.startIndex, offsetBy: self)
    }
}
