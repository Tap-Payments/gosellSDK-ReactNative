//
//  TapSystemPermission.swift
//  TapApplication
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// System permissions enum
///
/// - appleMusic: Apple Music
/// - bluetooth: Bluetooth
/// - calendar: Calendar
/// - camera: Camera
/// - contacts: Contacts
/// - health: Health
/// - home: Home
/// - location: Location
/// - microphone: Microphone
/// - motion: Motion
/// - photos: Photos
/// - reminders: Reminders
/// - siri: Siri
/// - speechRecognition: Speech recognition
/// - tvProviderAccount: TP Provider Account
public enum TapSystemPermission {

    case appleMusic
    case bluetooth
    case calendar
    case camera
    case contacts
    case health(TapHealthPermission)
    case home
    case location(TapLocationPermission)
    case microphone
    case motion
    case photos
    case reminders
    case siri
    case speechRecognition
    case tvProviderAccount

    // MARK: - Internal -

    internal var plistKeys: [String] {

        switch self {

        case .appleMusic:               return [PlistKey.appleMusic]
        case .bluetooth:                return [PlistKey.bluetooth]
        case .calendar:                 return [PlistKey.calendar]
        case .camera:                   return [PlistKey.camera]
        case .contacts:                 return [PlistKey.contacts]
        case .health(let context):      return context.plistKeys
        case .home:                     return [PlistKey.home]
        case .location(let context):    return context.plistKeys
        case .microphone:               return [PlistKey.microphone]
        case .motion:                   return [PlistKey.motion]
        case .photos:                   return [PlistKey.photos]
        case .reminders:                return [PlistKey.reminders]
        case .siri:                     return [PlistKey.siri]
        case .speechRecognition:        return [PlistKey.speechRecognition]
        case .tvProviderAccount:        return [PlistKey.tvProviderAccount]
        }
    }

    // MARK: - Private -

    private struct PlistKey {

        fileprivate static let appleMusic           = "NSAppleMusicUsageDescription"
        fileprivate static let bluetooth            = "NSBluetoothPeripheralUsageDescription"
        fileprivate static let calendar             = "NSCalendarsUsageDescription"
        fileprivate static let camera               = "NSCameraUsageDescription"
        fileprivate static let contacts             = "NSContactsUsageDescription"
        fileprivate static let home                 = "NSHomeKitUsageDescription"
        fileprivate static let microphone           = "NSMicrophoneUsageDescription"
        fileprivate static let motion               = "NSMotionUsageDescription"
        fileprivate static let photos               = "NSPhotoLibraryUsageDescription"
        fileprivate static let reminders            = "NSRemindersUsageDescription"
        fileprivate static let siri                 = "NSSiriUsageDescription"
        fileprivate static let speechRecognition    = "NSSpeechRecognitionUsageDescription"
        fileprivate static let tvProviderAccount    = "NSVideoSubscriberAccountUsageDescription"

        //@available(*, unavailable) private init() {}
    }
}

/// TapHealPermission
///
/// - share: Permission to share health data.
/// - update: Permission to update health data.
public enum TapHealthPermission {

    case share
    case update

    // MARK: - Fileprivate -
    // MARK: Properties

    fileprivate var plistKeys: [String] {

        switch self {

        case .share:    return [PlistKey.share]
        case .update:   return [PlistKey.update]

        }
    }

    // MARK: - Private -

    private struct PlistKey {

        fileprivate static let share    = "NSHealthShareUsageDescription"
        fileprivate static let update   = "NSHealthUpdateUsageDescription"

        //@available(*, unavailable) private init() {}
    }
}

// MARK: - TapLocationPermission -

/// TapLocationPermission
///
/// - any: At least any permission.
/// - whenInUse: Permission to use location when app is in foreground.
/// - always: Permission to use location always.
public enum TapLocationPermission {

    case any
    case whenInUse
    case always

    // MARK: - Fileprivate -
    // MARK: Properties

    fileprivate var plistKeys: [String] {

        switch self {

        case .any:          return [PlistKey.whenInUse, PlistKey.always]
        case .whenInUse:    return [PlistKey.whenInUse]
        case .always:       return [PlistKey.always]

        }
    }

    // MARK: - Private -

    private struct PlistKey {

        fileprivate static let whenInUse    = "NSLocationWhenInUseUsageDescription"
        fileprivate static let always       = "NSLocationAlwaysUsageDescription"

        //@available(*, unavailable) private init() {}
    }
}
