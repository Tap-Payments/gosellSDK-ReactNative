//
//  FontProvider.swift
//  TapFontsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import func 	CoreText.CTFontManager.CTFontManagerRegisterGraphicsFont
import class	TapAdditionsKitV2.Bundle
import func 	TapSwiftFixes.synchronized
import class	UIKit.UIFont.UIFont

/*!
 @class         FontProvider
 @abstract      Utility class to retreive localized fonts.
 */
public class FontProvider {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Returns localized variant of font with a given original name of a given size for a given locale.
    ///
    /// - Parameters:
    ///   - originalName: Original font name.
    ///   - size: Font size
    ///   - languageIdentifier: Language identifier.
    /// - Returns: UIFont
    public static func localizedFont(_ originalName: TapFont, size: CGFloat, languageIdentifier: String) -> UIFont {
        
        var fontName: TapFont
        
        #if TARGET_INTERFACE_BUILDER
            
            fontName = originalName
            
        #else
            
            if languageIdentifier == Locale.TapLocaleIdentifier.ar {
                
                fontName = self.arabicFontNames[originalName] ?? .arabicHelveticaNeueRegular
            }
            else {
                
                fontName = originalName
            }
            
        #endif
        
        return self.fontWith(name: fontName, size: size)
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func fontWith(name: TapFont, size: CGFloat) -> UIFont {
		
		switch name {
			
		case .system(let systemFontName):
			
			guard let font = UIFont(name: systemFontName, size: size) else {
				
				fatalError("Failed to instantiate font \(systemFontName)")
			}
			
			return font
			
		default:
			
			break
		}
		
        return synchronized(self.loadedFonts) {
			
			if !self.loadedFonts.contains(name), self.loadFont(name) {
				
				self.loadedFonts.insert(name)
			}
			
			guard let font = UIFont(name: name.fileName, size: size) else {
				
                fatalError("Failed to instantiate font \(name.fileName)")
            }
            
            return font
        }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let resourcesBundleName = "Fonts"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private static var arabicFontNames: [TapFont: TapFont] = {
        
        return [
            
            .helveticaNeueThin: 	.arabicHelveticaNeueLight,
            .helveticaNeueLight: 	.arabicHelveticaNeueLight,
            .helveticaNeueMedium: 	.arabicHelveticaNeueRegular,
            .helveticaNeueRegular:	.arabicHelveticaNeueRegular,
            .helveticaNeueBold: 	.arabicHelveticaNeueBold,
            .circeExtraLight: 		.arabicHelveticaNeueLight,
            .circeLight: 			.arabicHelveticaNeueLight,
            .circeRegular: 			.arabicHelveticaNeueRegular,
            .circeBold: 			.arabicHelveticaNeueBold
        ]
    }()
    
    private static var loadedFonts: Set<TapFont> = {
        
        let fonts: [TapFont] = [
            
            .helveticaNeueThin,
            .helveticaNeueLight,
            .helveticaNeueMedium,
            .helveticaNeueRegular,
            .helveticaNeueBold
        ]
        
        return Set<TapFont>(fonts)
    }()
    
    private static let resourcesBundle: Bundle = {
       
        guard let bundle = Bundle(for: FontProvider.self).tap_childBundle(named: Constants.resourcesBundleName) else {
            
            fatalError("There is no bundle named \(Constants.resourcesBundleName)")
        }
        
        return bundle
    }()
    
    // MARK: Methods
    
    @available(*, unavailable) private init() {}
    
    private static func loadFont(_ fontName: TapFont) -> Bool {
        
        guard let fontURL = self.resourcesBundle.url(forResource: fontName.fileName, withExtension: fontName.fileExtension) else {
            
            print("There is no \(fontName.fileName).\(fontName.fileExtension) in fonts bundle.")
			return false
        }
        
        guard let fontData = try? Data(contentsOf: fontURL) else {
            
            print("Failed to load \(fontName.fileName).\(fontName.fileExtension) from fonts bundle.")
			return false
        }
        
        guard let dataProvider = CGDataProvider(data: fontData as CFData) else {
            
            print("Font data for \(fontName.fileName).\(fontName.fileExtension) is incorrect.")
			return false
        }
        
        guard let font = CGFont(dataProvider) else {
            
            print("Font data for \(fontName.fileName).\(fontName.fileExtension) is incorrect.")
			return false
        }
        
        var error: Unmanaged<CFError>? = nil
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            
            if let nonnullError = error, let errorDescription = CFErrorCopyDescription(nonnullError.takeRetainedValue()) {
				
                print("Error occured while registering font: \(errorDescription)")
				return false
            }
        }
		
		return true
    }
}
