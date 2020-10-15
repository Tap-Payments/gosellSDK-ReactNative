//
//  Bool+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

// MARK: - ExpressibleByIntegerLiteral
extension Bool: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        
        self.init(value != 0)
    }
}
