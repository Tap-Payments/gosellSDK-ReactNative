//
//  TapApplicationWithPlist.swift
//  TapApplication
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

/// Protocol to retrieve interesting plist info from the main application bundle.
public protocol TapApplicationWithPlist: ClassProtocol, TapBundleWithPlist {}

public extension TapApplicationWithPlist {

    // MARK: - Public -
    // MARK: Properties

    /// Application display name.
    var displayName: String {

        return self.plistObject(for: TapBundleInfoKeys.displayName) ?? .tap_empty
    }

    /// Application short version ( e.g. "1.1" )
    var shortVersion: String {

        return self.shortVersionString ?? .tap_empty
    }

    /// Application build string.
    var build: String {

        return self.bundleVersion ?? .tap_empty
    }

    /// Deep link URL scheme (if present).
    var deepLinkURLScheme: String? {

        guard let urlTypes: [[String: Any]] = self.plistObject(for: InfoPlistKeys.urlTypes) else { return nil }

        let bundleID = self.bundleIdentifier

        for type in urlTypes {

            guard let bundleURLName = type[InfoPlistKeys.URLTypes.urlName] as? String, bundleURLName == bundleID else { continue }
            guard let urlSchemes = type[InfoPlistKeys.URLTypes.urlSchemes] as? [String], urlSchemes.count > 0 else { continue }

            guard urlSchemes.filter({ $0.hasPrefix(InfoPlistKeys.URLTypes.tagmanager) }).count == 0 else { continue }

            return urlSchemes.first
        }

        return nil
    }

    // MARK: - Internal -
    // MARK: Methods

    internal func infoPlistString(for key: String) -> String {

        return self.plistObject(for: key) ?? .tap_empty
    }
}

private struct InfoPlistKeys {

    fileprivate static let urlTypes = "CFBundleURLTypes"

    fileprivate struct URLTypes {

        fileprivate static let tagmanager = "tagmanager"
        fileprivate static let urlName = "CFBundleURLName"
        fileprivate static let urlSchemes = "CFBundleURLSchemes"

        //@available(*, unavailable) private init() {}
    }

    //@available(*, unavailable) private init() {}
}
