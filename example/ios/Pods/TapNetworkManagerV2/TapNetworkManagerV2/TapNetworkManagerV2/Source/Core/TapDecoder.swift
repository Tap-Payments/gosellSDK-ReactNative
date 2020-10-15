//
//  TapDecoder.swift
//  TapNetworkManager/Core
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Tap Decoder.
internal protocol TapDecoder {

    associatedtype DecodedType

    /// Decodes data into given `DecodedType`
    ///
    /// - Parameter data: Data to decode.
    /// - Returns: Decoded data.
    /// - Throws: Serialization error in case data cannot be decoded or has wrong format.
    func decode(_ data: Any) throws -> DecodedType
}
