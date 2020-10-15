//
//  NumberFormatter+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation

/// Useful extension for NumberFormatter.
public extension NumberFormatter {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Initializes NumberFormatter with a given locale identifer.
    ///
    /// - Parameter localeIdentifier: Locale identifier.
    convenience init(localeIdentifier: String) {
        
        let loc = Locale(identifier: localeIdentifier)
        self.init(locale: loc)
    }
    
    /// Initializes number formatter with a given locale.
    ///
    /// - Parameter locale: Locale.
    convenience init(locale: Locale) {
        
        self.init()
        self.locale = locale
    }
}
