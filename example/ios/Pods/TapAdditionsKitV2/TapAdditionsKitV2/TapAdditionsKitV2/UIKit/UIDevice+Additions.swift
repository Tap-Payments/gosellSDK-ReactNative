//
//  UIDevice+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	Foundation.NSProcessInfo.OperatingSystemVersion
import class	Foundation.NSProcessInfo.ProcessInfo
import class	UIKit.UIDevice

/// Useful extension for UIDevice.
public extension UIDevice {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns OS version.
    var tap_operatingSystemVersion: OperatingSystemVersion {
        
        return ProcessInfo.processInfo.operatingSystemVersion
    }
    
    /// Defines if device is running iOS 9 or lower
    var tap_isRunningIOS9OrLower: Bool {
        
        return self.tap_operatingSystemVersion.majorVersion < 10
    }
    
    /// Defines if device is running iOS 8 or lower
    var tap_isRunningIOS8OrLower: Bool {
        
        return self.tap_operatingSystemVersion.majorVersion < 9
    }
    
    /// Defines if app is running on simulator.
    var tap_isSimulator: Bool {
        
        #if targetEnvironment(simulator)
            
            return true
            
        #else
            
            return false
            
        #endif
    }
    
    /// Defines if device is 64-bit.
    var tap_is64Bit: Bool {
        
        #if __LP64__
            
            return true
            
        #else
            
            return false
            
        #endif
    }
    
    /// Defines if device is iPad
    var tap_isIPad: Bool {
        
        return self.userInterfaceIdiom == .pad
    }
}
