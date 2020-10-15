//
//  Locale+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation

/// Useful extension to Locale class.
public extension Locale {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns en_US locale.
    static let tap_enUS = Locale(identifier: TapLocaleIdentifier.enUS)
    
    /// Locale identifiers.
    struct TapLocaleIdentifier {
        
        public static let ar = "ar"
        public static let en = "en"
        public static let enUS = "en_US"
    }
    
    // MARK: Methods
    
    /// Returns primary locale identifier from a given locale identifier.
    ///
    /// - Parameter localeIdentifier: Locale identifier, for example "en-US"
    /// - Returns: Primary locale identifier, for example "en".
    static func tap_primaryLocaleIdentifier(from localeIdentifier: String) -> String {
        
        let languageCodeKey = NSLocale.Key.languageCode.rawValue
        let components = self.components(fromIdentifier: localeIdentifier)
        
        if let result = components[languageCodeKey] {
            
            return result
        }
        
        let characters = "\(LocaleSeparator.dash)\(LocaleSeparator.underscore)"
        let charactersSet = CharacterSet(charactersIn: characters)
        
        return localeIdentifier.components(separatedBy: charactersSet)[0]
    }
    
    // MARK: - Private -
    private struct LocaleSeparator {
        
        fileprivate static let dash = "-"
        fileprivate static let underscore = "_"
    }
}
