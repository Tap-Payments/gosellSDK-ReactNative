//
//  Level+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class	UIKit.UIApplication.UIApplication
import class	UIKit.UIWindow.UIWindow

/// Useful extension for UIWindowLevel
public extension UIWindow.Level {
    
    // MARK: - Public
    // MARK: Properties
	
	/// Raw value
	var tap_rawValue: CGFloat {
		
		#if swift(>=4.2)
		
		return self.rawValue
		
		#else
		
		return self
		
		#endif
	}
    
    /// Returns maximal window level among all presented windows in the app.
    static var tap_maximalAmongPresented: UIWindow.Level {
        
        return self.tap_maximalAmongPresented(lower: UIWindow.Level(CGFloat.greatestFiniteMagnitude))
    }
    
    // MARK: Methods
    
    /// Returns maximal window level among presented in the app lower then the specified window level.
    ///
    /// - Parameter then: Specified window level.
    /// - Returns: Maximal found window level lower then the specified one or 'then' if the window not found.
    static func tap_maximalAmongPresented(lower then: UIWindow.Level) -> UIWindow.Level {
        
        let windows = UIApplication.shared.windows.filter { $0.windowLevel < then }
        guard windows.count > 0 else { return UIWindow.Level(then.tap_rawValue - 1.0) }
        
        guard let firstWindow = (windows.sorted { $0.windowLevel > $1.windowLevel }).first else {
            
            fatalError("Something wrong happened. Please recompile.")
        }
        
        return firstWindow.windowLevel
    }
    
    /// Returns minimal window level among presented in the app higher then the specified window level.
    ///
    /// - Parameter then: Specified window level.
    /// - Returns: Minimal found window level higher then the specified one or 'then' if the window not found.
    static func tap_minimalAmongPresented(higher then: UIWindow.Level) -> UIWindow.Level {
        
        let windows = UIApplication.shared.windows.filter { $0.windowLevel > then }.sorted { $0.windowLevel < $1.windowLevel }
        guard windows.count > 0 else { return then }
        
        return windows[0].windowLevel
    }
}
