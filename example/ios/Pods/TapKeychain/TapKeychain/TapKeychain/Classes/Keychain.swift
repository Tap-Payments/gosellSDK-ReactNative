//
//  Keychain.swift
//  TapKeychain
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Keychain class.
public final class Keychain {

    // MARK: - Public -
    // MARK: Methods

    /// Writes `object` to keychain for a given `key`.
    ///
    /// - Parameters:
    ///   - object: Object to write to keychain.
    ///   - key: Key.
    /// - Returns: Boolean matching the status.
    @discardableResult public static func write<Object: KeychainRepresentable>(_ object: Object?, for key: String) -> Bool {

        guard let nonnullObject = object else {

            return self.removeObject(for: key)
        }

        if self.objectExists(for: key) {

            return self.update(nonnullObject, for: key)

        } else {

            return self.create(nonnullObject, for: key)
        }
    }

    /// Reads an object from keychain for a given key.
    ///
    /// - Parameter key: Key to read the object at.
    /// - Returns: An object or nil if there is no object in keychain or it failed to be initialized from keychain data.
    @discardableResult public static func read<Object: KeychainRepresentable>(for key: String) -> Object? {

        if let data = self.objectData(for: key) {

            return Object(tap_keychainData: data)

        } else {

            return nil
        }
    }

    /// Removes the object from keychain at a given key.
    ///
    /// - Parameter key: Key to remove the object.
    /// - Returns: Boolean indicating the status.
    @discardableResult public static func removeObject(for key: String) -> Bool {

        return self.deleteObject(for: key)
    }

    /// Defines if an object is existing in keychain for a given key.
    ///
    /// - Parameter key: Object key.
    /// - Returns: Boolean indicating whether an object is existing in keychain.
    public static func objectExists(for key: String) -> Bool {

        return self.objectData(for: key) != nil
    }

    // MARK: - Private -
    // MARK: Methods

    @available(*, unavailable) private init() { fatalError("Keychain class cannot be instantiated.") }

    private static func objectData(for key: String) -> Data? {

        guard var searchDictionary = self.createSearchDictionary(for: key) else { return nil }

        searchDictionary[kSecMatchLimit as String] = kSecMatchLimitOne
        searchDictionary[kSecReturnData as String] = kCFBooleanTrue

        var retrievedData: AnyObject?
        let status = SecItemCopyMatching(searchDictionary as CFDictionary, &retrievedData)

        if status == errSecSuccess {

            return retrievedData as? Data

        } else {

            return nil
        }
    }

    private static func create<Object: KeychainRepresentable>(_ object: Object, for key: String) -> Bool {

        guard var searchDictionary = self.createSearchDictionary(for: key) else { return false }

        guard let objectData = self.getData(from: object) else { return false }

        searchDictionary[kSecValueData as String] = objectData

        let status = SecItemAdd(searchDictionary as CFDictionary, nil)

        return status == errSecSuccess
    }

    private static func update<Object: KeychainRepresentable>(_ object: Object, for key: String) -> Bool {

        guard let searchDictionary = self.createSearchDictionary(for: key) else { return false }
        guard let objectData = self.getData(from: object) else { return false }

        let updateDictionary = [kSecValueData: objectData]

        let status = SecItemUpdate(searchDictionary as CFDictionary, updateDictionary as CFDictionary)
        return status == errSecSuccess
    }

    private static func deleteObject(for key: String) -> Bool {

        guard let searchDictionary = self.createSearchDictionary(for: key) else { return false }
        let status = SecItemDelete(searchDictionary as CFDictionary)

        return status == errSecSuccess
    }

    private static func createSearchDictionary(for key: String) -> [String: Any]? {

        guard let keyData = key.data(using: .utf8, allowLossyConversion: false) else {

            print("\(key) is not convertible to UTF-8 data. Please use another key.")
            return nil
        }

        guard var searchDictionary = self.createBasicDictionary() else { return nil }

        searchDictionary[kSecAttrGeneric as String] = keyData
        searchDictionary[kSecAttrAccount as String] = keyData

        return searchDictionary
    }

    private static func createBasicDictionary() -> [String: Any]? {

        guard let serviceName = Bundle(for: self).infoDictionary?[kCFBundleIdentifierKey as String] as? String else {

            print("Something went wrong. TapKechain framework doesn't have bundle identifier?")
            return nil
        }

        return [

            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: serviceName
        ]
    }

    private static func getData<Object: KeychainRepresentable>(from object: Object) -> Data? {

        guard let result = object.tap_toKeychainData() else {

            print("Failed to create data from \(object).")
            return nil
        }

        return result
    }
}
