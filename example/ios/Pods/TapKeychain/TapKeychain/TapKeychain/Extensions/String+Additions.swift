//
//  String+Additions.swift
//  TapKeychain
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

extension String: KeychainRepresentable {

    public func tap_toKeychainData() -> Data? {

        return self.data(using: .utf8, allowLossyConversion: false)
    }

    public init?(tap_keychainData: Data) {

        self.init(data: tap_keychainData, encoding: .utf8)
    }
}
