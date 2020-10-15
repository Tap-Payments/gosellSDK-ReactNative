//
//  TapApplicationPlistInfo.swift
//  TapApplication
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Dummy class to get application plist information.
public class TapApplicationPlistInfo {

    // MARK: - Public -
    // MARK: Properties

    public static let shared = TapApplicationPlistInfo()

    // MARK: Methods

    /// Returns `true` if application's `Info.plist` file contains usage description for the given `permission`, `false` otherwise.
    ///
    /// - Parameter permission: System permission.
    /// - Returns: `true` if application's `Info.plist` file contains usage description for the given `permission`, `false` otherwise.
    public func hasUsageDescription(for permission: TapSystemPermission) -> Bool {

        return self.usageDescriptions(for: permission) != nil
    }

    /// Returns list of usage descriptions taken from the application's `Info.plist` file or `nil` if there are no descriptions for the given `permission`.
    ///
    /// - Parameter permission: System permission.
    /// - Returns:  List of usage descriptions taken from the application's `Info.plist` file or `nil` if there are no descriptions for the given `permission`.
    public func usageDescriptions(for permission: TapSystemPermission) -> [String]? {

        let keys = permission.plistKeys

        let result: [String] = keys.compactMap { if let text: String = self.plistObject(for: $0), text.tap_length > 0 { return text } else { return nil } }

        if result.count > 0 {

            return result

        } else {

            return nil
        }
    }

    // MARK: - Private -
    // MARK: Methods

    private init() {}
}

// MARK: - TapApplicationWithPlist
extension TapApplicationPlistInfo: TapApplicationWithPlist {

    public var bundle: Bundle {

        return .main
    }
}
