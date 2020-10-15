//
//  TapBlurEffectStyle.swift
//  TapVisualEffectView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	UIKit.UIBlurEffect.UIBlurEffect
import class	UIKit.UIColor.UIColor

/// Tap Blur Effect Style.
///
/// - none: No blur.
/// - light: Light blur style.
/// - extraLight: Extra light blur style.
/// - dark: Dark blur style.
/// - prominent: Prominent blur style.
/// - regular: Regular blur style.

public enum TapBlurEffectStyle {
	
	case none
    case light
    case extraLight
    case dark
	
	@available(iOS 10.0, *)
	case prominent
	
	@available(iOS 10.0, *)
	case regular
	
    
    internal var blurEffect: UIBlurEffect? {
        
        switch self {
            
        case .light:
            
            return UIBlurEffect(style: .light)
            
        case .extraLight:
            
            return UIBlurEffect(style: .extraLight)
            
        case .dark:
            
            return UIBlurEffect(style: .dark)
			
		case .prominent:
			
			if #available(iOS 10.0, *) {
				
				return UIBlurEffect(style: .prominent)
			}
			else {
				
				fatalError("Prominent blur style is not available on iOS versions before 10.0")
			}
			
		case .regular:
			
			if #available(iOS 10.0, *) {
				
				return UIBlurEffect(style: .regular)
			}
			else {
				
				fatalError("Regular blur style is not available on iOS versions before 10.0")
			}
            
        default:
            
            return nil
        }
    }
    
    internal var tintColor: UIColor {
        
        switch self {
            
        case .light, .regular:
			
            return .tap_lightBlurTintColor
            
        case .extraLight, .prominent:
            
            return .tap_extraLightBlurTintColor
            
        case .dark:
            
            return .tap_darkBlurTintColor
            
        default:
            
            return .clear
        }
    }
}

// MARK: - CaseIterable
extension TapBlurEffectStyle: CaseIterable {
	
	public static var allCases: [TapBlurEffectStyle] {
		
		if #available(iOS 10.0, *) {
			
			return [
			
				.none,
				.light,
				.extraLight,
				.dark,
				.prominent,
				.regular
			]
		}
		else {
			
			return [
				
				.none,
				.light,
				.extraLight,
				.dark
			]
		}
	}
}
