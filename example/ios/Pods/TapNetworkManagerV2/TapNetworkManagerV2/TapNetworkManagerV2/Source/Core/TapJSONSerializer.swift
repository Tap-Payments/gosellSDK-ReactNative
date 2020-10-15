//
//  TapJSONSerializer.swift
//  TapNetworkManager/Core
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation

/// Tap JSON serializer class.
internal class TapJSONSerializer {

    // MARK: - Internal -
    // MARK: Properties

    internal static let shared = TapJSONSerializer()

    // MARK: - Private -
    // MARK: Methods

    private init() {}
}

// MARK: - TapEncoder
extension TapJSONSerializer: TapEncoder {

    internal typealias EncodedType = Data

    internal func encode(_ data: Any) throws -> Data {

        return try JSONSerialization.data(withJSONObject: data, options: [])
    }
}

// MARK: - TapDecoder
extension TapJSONSerializer: TapDecoder {

    internal typealias DecodedType = Any

    internal func decode(_ data: Any) throws -> Any {

        guard let d = data as? Data else {

            throw TapNetworkError.serializationError(.wrongData)
        }

        return try JSONSerialization.jsonObject(with: d, options: [])
    }
}
