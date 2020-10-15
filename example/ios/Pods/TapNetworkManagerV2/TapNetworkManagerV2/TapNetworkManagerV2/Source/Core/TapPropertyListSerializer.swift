//
//  TapPropertyListSerializer.swift
//  TapNetworkManager/Core
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation

/// Property list serializer.
internal class TapPropertyListSerializer {

    // MARK: - Internal -
    // MARK: Properties

    /// Shared instance.
    internal static let shared = TapPropertyListSerializer()

    // MARK: - Private -
    // MARK: Methods

    private init() {}
}

// MARK: - TapEncoder
extension TapPropertyListSerializer: TapEncoder {

    internal typealias EncodedType = Data

    internal func encode(_ data: Any) throws -> Data {

        let allFormats: [PropertyListSerialization.PropertyListFormat] = [.xml, .binary, .openStep]

        for format in allFormats {

            if PropertyListSerialization.propertyList(data, isValidFor: format) {

                return try PropertyListSerialization.data(fromPropertyList: data, format: format, options: 0)
            }
        }

        throw TapNetworkError.serializationError(.wrongData)
    }
}

// MARK: - TapDecoder
extension TapPropertyListSerializer: TapDecoder {

    internal typealias DecodedType = Any

    internal func decode(_ data: Any) throws -> Any {

        guard let d = data as? Data else {

            throw TapNetworkError.serializationError(.wrongData)
        }

        return try PropertyListSerialization.propertyList(from: d, options: [], format: nil)
    }
}
