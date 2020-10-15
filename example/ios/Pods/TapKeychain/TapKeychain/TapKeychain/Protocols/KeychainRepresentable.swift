//
//  KeychainRepresentable.swift
//  TapKeychain
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Keychain representable protocol.
public protocol KeychainRepresentable {

    /// Converts the receiver to `Data`.
    ///
    /// - Returns: Data representation of the receiver or `nil` if the receiver cannot be represented as `Data`.
    func tap_toKeychainData() -> Data?

    /// Initializes an instance from its keychain data representation.
    ///
    /// - Parameter data: Data
    init?(tap_keychainData: Data)
}
