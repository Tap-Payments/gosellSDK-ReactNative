//
//  Bundle+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	Foundation.NSBundle.Bundle

/// Useful extension for Bundle.
public extension Bundle {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Returns child bundle with a specific name.
    ///
    /// - Parameter name: Child bundle name.
    /// - Returns: Child bundle.
    func tap_childBundle(named name: String) -> Bundle? {
        
        guard let bundleURL = self.url(forResource: name, withExtension: BundleConstants.bundleExtension) else {
            
            return nil
        }
        
        return Bundle(url: bundleURL)
    }
    
    // MARK: - Private -
    
    private struct BundleConstants {
        
        fileprivate static let bundleExtension = "bundle"
        
        //@available(*, unavailable) private init() {}
    }
}
