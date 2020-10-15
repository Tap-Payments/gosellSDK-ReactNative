//
//  Decodable+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation

/// Useful extension to Decodable protocol.
public extension Decodable {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Initializes Decodable instance with the dictionary using specified decoder.
    ///
    /// - Parameters:
    ///   - dictionary: Dictionary to decode.
    ///   - decoder: Decoder.
    /// - Throws: Decoding error.
    init(dictionary: [String: Any], using decoder: JSONDecoder = JSONDecoder()) throws {
        
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        self = try decoder.decode(Self.self, from: jsonData)
    }
}
