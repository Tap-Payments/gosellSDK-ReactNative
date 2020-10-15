//
//  DateFormatter+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation

/// Useful extension to DateFormatter.
public extension DateFormatter {
    
    // MARK: - Public -
    // MARK: Methods
    
    /**
     Initializes new instance of NSDateFormatter with given locale and date format.
     
     - parameter locale:     Locale.
     - parameter dateFormat: Date format.
     
     - returns: New instance of NSDateFormatter.
     */
    convenience init(locale: Locale, dateFormat: String) {
        
        self.init()
        
        self.locale = locale
        self.dateFormat = dateFormat
    }
}
