//
//  Data+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func		ObjectiveC.autoreleasepool
import Foundation
import class	UIKit.UIImage.UIImage
import func		UIKit.UIImage.UIImagePNGRepresentation

/// Useful extension to Data struct.
public extension Data {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns hexademical string.
    var tap_hexString: String {
        
        return self.reduce(String.tap_empty, {$0 + String(format: "%02X", $1)})
    }
    
    // MARK: Methods
    
    /*!
     Creates and returns data representation of UIImage
     
     - parameter image: Image to create data.
     
     - returns: Data
     */
    static func tap_dataWith(image: UIImage?) -> Data? {
        
        guard let transparentImage = image?.tap_transparentImage else { return nil }
        
        var data: Data?
        
        return autoreleasepool {

            data = transparentImage.tap_pngData
            return data
        }
    }
}
