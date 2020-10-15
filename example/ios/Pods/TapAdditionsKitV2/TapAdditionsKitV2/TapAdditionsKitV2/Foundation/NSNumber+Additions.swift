//
//  NSNumber+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import Foundation
import class	UIKit.UIDevice.UIDevice

/// Useful extension for NSNumber.
public extension NSNumber {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Zero number.
    static let tap_zero = NSNumber(value: 0.0)
    
    /// Returns CGFloat value.
    var tap_cgFloatValue: CGFloat {
        
        if UIDevice.current.tap_is64Bit {
            
            return CGFloat(self.floatValue)
        }
        else {
            
            return CGFloat(self.doubleValue)
        }
    }
    
    /// Returns string value of the receiver using en_US locale without grouping separator.
    var tap_internationalStringValue: String {
        
        if let result = type(of: self).tap_decimalNumberFormatter.string(from: self) {
            
            return result
        }
        else {
            
            return "0"
        }
    }
    
    // MARK: Methods
    
    /*!
     Initialized NSNumber with CGFloat value.
     
     - parameter value: Value
     
     - returns: NSNumber
     */
    convenience init(cgFloat value: CGFloat) {
        
        if UIDevice.current.tap_is64Bit {
            
            self.init(value: Double(value))
        }
        else {
            
            self.init(value: Float(value))
        }
    }
    
    /*!
     Creates and returns number from a given string.
     
     - parameter string: String to generate number.
     
     - returns: NSNumber
     */
    static func tap_from(string: String?) -> NSNumber {
        
        guard let nonnullString = string else { return .tap_zero }
        
        if let numberFromString = self.tap_decimalNumberFormatter.number(from: nonnullString) {
            
            return numberFromString
        }
        else {
            
            return .tap_zero
        }
    }
    
    // MARK: Private
    
    private static var tap_decimalNumberFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter(locale: Locale.tap_enUS)
        formatter.groupingSeparator = String.tap_empty
        formatter.numberStyle = NumberFormatter.Style.decimal
        
        return formatter
    }()
}
