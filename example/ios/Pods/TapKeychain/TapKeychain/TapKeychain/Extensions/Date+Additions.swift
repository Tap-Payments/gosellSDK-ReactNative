//
//  Date+Additions.swift
//  TapKeychain
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

extension Date: KeychainRepresentable {

    public func tap_toKeychainData() -> Data? {

        return NSKeyedArchiver.archivedData(withRootObject: self)
    }

    public init?(tap_keychainData: Data) {

        if let result = NSKeyedUnarchiver.unarchiveObject(with: tap_keychainData) as? Date {

            self = result

        } else {

            return nil
        }
    }
}
