//
//  TapBundleWithPlist.swift
//  TapApplication
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum UIKit.UIDevice.UIUserInterfaceIdiom

/// Protocol to retrieve most of the plist information from bundle.
public protocol TapBundleWithPlist {

    // MARK: Properties

    /// Bundle to retrieve information from.
    var bundle: Bundle { get }
}

public extension TapBundleWithPlist {

    // MARK: - Public -
    // MARK: Properties

    var buildMachineOSBuild: String? {

        return self.plistObject(for: TapBundleInfoKeys.buildMachineOSBuild)
    }

    var bundleDevelopmentRegion: String? {

        return self.plistObject(for: TapBundleInfoKeys.bundleDevelopmentRegion)
    }

    var bundleExecutable: String? {

        return self.plistObject(for: TapBundleInfoKeys.bundleExecutable)
    }

    var bundleIdentifier: String? {

        return self.plistObject(for: TapBundleInfoKeys.bundleIdentifier)
    }

    var bundleInfoDictionaryVersion: String? {

        return self.plistObject(for: TapBundleInfoKeys.bundleInfoDictionaryVersion)
    }

    var bundleName: String? {

        return self.plistObject(for: TapBundleInfoKeys.bundleName)
    }

    var bundleNumericVersion: Int64? {

        return self.plistObject(for: TapBundleInfoKeys.bundleNumericVersion)
    }

    var bundlePackageType: String? {

        return self.plistObject(for: TapBundleInfoKeys.bundlePackageType)
    }

    var shortVersionString: String? {

        return self.plistObject(for: TapBundleInfoKeys.shortVersionString)
    }

    var bundleSignature: String? {

        return self.plistObject(for: TapBundleInfoKeys.bundleSignature)
    }

    var supportedPlatforms: [String]? {

        return self.plistObject(for: TapBundleInfoKeys.supportedPlatforms)
    }

    var bundleVersion: String? {

        return self.plistObject(for: TapBundleInfoKeys.bundleVersion)
    }

    var compiler: String? {

        return self.plistObject(for: TapBundleInfoKeys.compiler)
    }

    var platformBuild: String? {

        return self.plistObject(for: TapBundleInfoKeys.platformBuild)
    }

    var platformName: String? {

        return self.plistObject(for: TapBundleInfoKeys.platformName)
    }

    var platformVersion: String? {

        return self.plistObject(for: TapBundleInfoKeys.platformVersion)
    }

    var sdkBuild: String? {

        return self.plistObject(for: TapBundleInfoKeys.sdkBuild)
    }

    var sdkName: String? {

        return self.plistObject(for: TapBundleInfoKeys.sdkName)
    }

    var xcodeVersion: String? {

        return self.plistObject(for: TapBundleInfoKeys.xcodeVersion)
    }

    var xcodeBuild: String? {

        return self.plistObject(for: TapBundleInfoKeys.xcodeBuild)
    }

    var minimumOSVersion: String? {

        return self.plistObject(for: TapBundleInfoKeys.minimumOSVersion)
    }

    var deviceFamily: [UIUserInterfaceIdiom]? {

        return self.plistObject(for: TapBundleInfoKeys.deviceFamily)
    }

    var requiredDeviceCapabilities: String? {

        return self.plistObject(for: TapBundleInfoKeys.requiredDeviceCapabilities)
    }

    // MARK: Methods

    internal func plistObject<ReturnType>(for key: String) -> ReturnType? {

        return self.bundle.object(forInfoDictionaryKey: key) as? ReturnType
    }
}
