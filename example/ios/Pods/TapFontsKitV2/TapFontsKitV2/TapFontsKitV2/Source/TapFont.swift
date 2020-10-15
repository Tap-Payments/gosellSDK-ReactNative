//
//  TapFont.swift
//  TapFontsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class 	UIKit.UIFont.UIFont

/// Font name enum
public enum TapFont {
	
    case helveticaNeueThin
    case helveticaNeueLight
    case helveticaNeueMedium
    case helveticaNeueRegular
    case helveticaNeueBold
    
    case circeExtraLight
    case circeLight
    case circeRegular
    case circeBold
    
    case arabicHelveticaNeueLight
    case arabicHelveticaNeueRegular
    case arabicHelveticaNeueBold
	
	case system(String)
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Returns localized ready-to-use UIFont instance.
    ///
    /// - Parameters:
    ///   - size: Point size.
    ///   - languageIdentifier: Language identifier.
    /// - Returns: Localized ready-to-use UIFont instance.
    public func localizedWithSize(_ size: CGFloat, languageIdentifier: String) -> UIFont {
        
        return FontProvider.localizedFont(self, size: size, languageIdentifier: languageIdentifier)
    }
    
    /// Returns non-localized ready-to-use UIFont instance.
    ///
    /// - Parameter size: Point size.
    /// - Returns: Non-localized ready-to-use UIFont instance.
    public func withSize(_ size: CGFloat) -> UIFont {
        
        return FontProvider.fontWith(name: self, size: size)
    }
	
    // MARK: - Internal -
    // MARK: Properties
    
    /// Font file name.
    internal var fileName: String {
        
        switch self {
            
        case .helveticaNeueThin: 	return "HelveticaNeue-Thin"
        case .helveticaNeueLight: 	return "HelveticaNeue-Light"
        case .helveticaNeueMedium: 	return "HelveticaNeue-Medium"
        case .helveticaNeueRegular:	return "HelveticaNeue"
        case .helveticaNeueBold: 	return "HelveticaNeue-Bold"
            
        case .circeExtraLight:	return "Circe-ExtraLight"
        case .circeLight: 		return "Circe-Light"
        case .circeRegular: 	return "Circe-Regular"
        case .circeBold: 		return "Circe-Bold"
            
        case .arabicHelveticaNeueLight: 	return "HelveticaNeueLTW20-Light"
        case .arabicHelveticaNeueRegular:	return "HelveticaNeueLTW20-Roman"
        case .arabicHelveticaNeueBold: 		return "HelveticaNeueLTW20-Bold"
			
		default:
			
			fatalError("System font is not accessible through its file.")
        }
    }
    
    /// Font file extension.
    internal var fileExtension: String {
        
        return "ttf"
    }
}

// MARK: - Hashable
extension TapFont: Hashable {
	
	public func hash(into hasher: inout Hasher) {
	
		switch self {
			
		case .system(let name): hasher.combine(name)
		default:				hasher.combine(self.fileName)

		}
	}
}
