//
//  TapEncoder.swift
//  TapNetworkManager/Core
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Tap Encoder.
internal protocol TapEncoder {

    associatedtype EncodedType

    /// Encodes the data into given `EncodedType`
    ///
    /// - Parameter data: Data to encode.
    /// - Returns: Encoded data.
    /// - Throws: Serialization error in case data cannot be encoded or has wrong format.
    func encode(_ data: Any) throws -> EncodedType
}
