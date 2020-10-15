//
//  TapBundleInfoKeys.swift
//  TapApplication
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Bundle info.plist keys constants.
internal struct TapBundleInfoKeys {

    // MARK: - Internal -
    // MARK: Properties

    internal static let buildMachineOSBuild         = "BuildMachineOSBuild"
    internal static let bundleDevelopmentRegion     = "\(kCFBundleDevelopmentRegionKey!)"
    internal static let bundleExecutable            = "\(kCFBundleExecutableKey!)"
    internal static let bundleIdentifier            = "\(kCFBundleIdentifierKey!)"
    internal static let bundleInfoDictionaryVersion = "\(kCFBundleInfoDictionaryVersionKey!)"
    internal static let bundleName                  = "\(kCFBundleNameKey!)"
    internal static let bundleNumericVersion        = "CFBundleNumericVersion"
    internal static let bundlePackageType           = "CFBundlePackageType"
    internal static let shortVersionString          = "CFBundleShortVersionString"
    internal static let bundleSignature             = "CFBundleSignature"
    internal static let supportedPlatforms          = "CFBundleSupportedPlatforms"
    internal static let bundleVersion               = "\(kCFBundleVersionKey!)"
    internal static let compiler                    = "DTCompiler"
    internal static let platformBuild               = "DTPlatformBuild"
    internal static let platformName                = "DTPlatformName"
    internal static let platformVersion             = "DTPlatformVersion"
    internal static let sdkBuild                    = "DTSDKBuild"
    internal static let sdkName                     = "DTSDKName"
    internal static let xcodeVersion                = "DTXcode"
    internal static let xcodeBuild                  = "DTXcodeBuild"
    internal static let minimumOSVersion            = "MinimumOSVersion"
    internal static let deviceFamily                = "UIDeviceFamily"
    internal static let requiredDeviceCapabilities  = "UIRequiredDeviceCapabilities"

    internal static let displayName                 = "CFBundleDisplayName"

    // MARK: - Private -

    /*@available(*, unavailable) private init() {

        fatalError("\(self) cannot be instantiated.")
    }*/
}
